//
//  Friend.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/21.
//

import Foundation
import SwiftData

@Model
class FriendData {
    @Attribute(.unique)
    var id: UUID
    var user_uid: String
    var name: String
    var name_id: String
    
    init(user_uid: String, name: String, name_id: String) {
        self.id = UUID()
        self.user_uid = user_uid
        self.name = name
        self.name_id = name_id
    }
}

class FriendDatastore {
    @MainActor static let shared = FriendDatastore()
    
    private var context: ModelContext
    
    private init?() {
        let fileName = "Friend"
        let sqliteURL = URL.documentsDirectory
          .appending(component: fileName)
          .appendingPathExtension("sqlite")
        
        // 1. Model 定義の型情報で Schema を初期化
        let schema = Schema([FriendData.self])
        // 2. Schema で ModelConfiguration を初期化
        let modelConfiguration = ModelConfiguration(schema: schema, url: sqliteURL)
        do {
            // 3. ModelConfiguration で ModelContainer で初期化
            let modelContainer = try ModelContainer(
                for: FriendData.self,
                configurations: modelConfiguration
            )
            // 4. ModelContainer で ModelContext で初期化
            self.context = ModelContext(modelContainer)
        } catch {
            print("Failed to initialize AuthTokenDatastore.")
            print(error)
            return nil
        }
    }
    
    
    func insert(data: FriendData) {
        do {
            context.insert(data)
            try context.save()
        } catch {
            print("friendData insert error")
            print(error)
        }
    }
    
    func fetchAll() -> [FriendData] {
        do {
            let data = try context.fetch(FetchDescriptor<FriendData>())
            if data.isEmpty {
                return []
            }
            return data
        } catch {
            print("friendData fetch error")
            print(error)
        }
        return []
    }
    
    func deleteAll() {
        do {
            let friends = try context.fetch(FetchDescriptor<FriendData>())
            for friend in friends {
                context.delete(friend)
            }
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func delete(user_uid: String, name_id: String) {
        do {
            let friends = try context.fetch(FetchDescriptor<FriendData>(
                predicate: #Predicate{$0.user_uid == user_uid && $0.name_id == name_id}
            ))
            for friend in friends {
                context.delete(friend)
            }
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func syncFriends() {
        Task {
            do {
                guard let friendData: [FriendData] = await CloudFriendssDatastore().fetchFriendData() else {
                    return
                }
                
                // transaction
                try context.transaction {
                    
                    do {
                        // delete all
                        for friend in try context.fetch(FetchDescriptor<FriendData>()) {
                            context.delete(friend)
                        }
                        print("delete all", try context.fetch(FetchDescriptor<FriendData>()).count)
                        
                        // insert one
                        for friend in friendData {
                            context.insert(friend)
                        }
                        
                        print("insert one", friendData.count)
                    } catch {
                        print("syncFriendData error")
                        print(error)
                        throw error
                    }
                    
                }
            } catch {
                print("syncFriendData error")
                print(error)
            }
        }
    }
            
    
    func isExistFriend(user_uid: String) -> Bool {
        do {
            let friends = try context.fetch(FetchDescriptor<FriendData>(
                predicate: #Predicate{$0.user_uid == user_uid}
            ))
            return !friends.isEmpty
        } catch {
            print("friendData fetch error")
            print(error)
        }
        return false
    }
    
    func fetchName(user_uid: String) -> String? {
        do {
            let friends = try context.fetch(FetchDescriptor<FriendData>(
                predicate: #Predicate{$0.user_uid == user_uid}
            ))
            return friends.first?.name
        } catch {
            print("friendData fetch error")
            print(error)
        }
        return nil
    }
}

class CloudFriendssDatastore {
    func fetchFriendData() async -> [FriendData]? {
        do {
            var res: [FriendData] = []
            let FriendsResponse = try await fetch_friends()
            for friend in FriendsResponse?.friends ?? [] {
                let one_friend = FriendData(user_uid: friend.uid, name: friend.name, name_id: friend.name_id)
                res.append(one_friend)
            }
            return res
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    private func fetch_friends() async throws -> FriendsResponse? {
        let url = URL(string: BaseUrl.url + "/friend/get")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = await Auth.getToken() else {
            print("missing token")
            return nil
        }
        let params = ["token": token]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        } catch {
            print("Invalid JSON format.")
            return nil
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(FriendsResponse.self, from: data)
        return response
    }
    
    
    struct FriendsResponse: Codable {
        let friends: [Response]
    }

    struct Response: Codable {
        let uid: String
        let name: String
        let name_id: String
    }
}
