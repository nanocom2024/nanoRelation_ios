//
//  StreetPass.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/22.
//

import Foundation
import SwiftData

@Model
class StreetPassData {
    @Attribute(.unique)
    var id: UUID
    var user_uid: String
    var timestamp: Date
    
    init(user_uid: String) {
        self.id = UUID()
        self.user_uid = user_uid
        self.timestamp = Date()
    }
}

class StreetPassDatastore {
    @MainActor static let shared = StreetPassDatastore()
    
    private var context: ModelContext
    
    private init?() {
        let fileName = "StreetPass"
        let sqliteURL = URL.documentsDirectory
          .appending(component: fileName)
          .appendingPathExtension("sqlite")
        
        // 1. Model 定義の型情報で Schema を初期化
        let schema = Schema([StreetPassData.self])
        // 2. Schema で ModelConfiguration を初期化
        let modelConfiguration = ModelConfiguration(schema: schema, url: sqliteURL)
        do {
            // 3. ModelConfiguration で ModelContainer で初期化
            let modelContainer = try ModelContainer(
                for: StreetPassData.self,
                configurations: modelConfiguration
            )
            // 4. ModelContainer で ModelContext で初期化
            self.context = ModelContext(modelContainer)
        } catch {
            print("Failed to initialize StreetPassDatastore.")
            print(error)
            return nil
        }
    }
    
    
    func insert(data: StreetPassData) {
        do {
            context.insert(data)
            try context.save()
        } catch {
            print("StreetPassData insert error")
            print(error)
        }
    }
    
    func fetchAll() -> [StreetPassData] {
        do {
            let data = try context.fetch(FetchDescriptor<StreetPassData>())
            if data.isEmpty {
                return []
            }
            return data
        } catch {
            print("StreetPassData fetch error")
            print(error)
        }
        return []
    }
    
    @MainActor func fetchByUserUid(user_uid: String) -> [StreetPassData] {
        do {
            let data = try context.fetch(FetchDescriptor<StreetPassData>(
                predicate: #Predicate{$0.user_uid == user_uid}
            ))
            if data.isEmpty {
                return []
            }
            return data
        } catch {
            print("StreetPassData fetch error")
            print(error)
        }
        return []
    }
    

    @MainActor func received(major: String, minor: String) {
        guard let user_uid = PairingDatastore.shared?.fetch_user_uid(major: major, minor: minor) else {
            return
        }
        
        let data = StreetPassData(user_uid: user_uid)
        do {
            let allData = try context.fetch(FetchDescriptor<StreetPassData>(
                predicate: #Predicate{$0.user_uid == user_uid}
            ))
            if allData.isEmpty {
                insert(data: data)
                
                if let name = FriendDatastore.shared?.fetchName(user_uid: user_uid) {
                    print("send pass notification")
                    NotificationManager().sendPassNotification(name: name)
                }
                return
            }
            
            let latestData = allData.sorted(by: { $0.timestamp > $1.timestamp }).first
            let date = Date()
            let timeDifference = date.timeIntervalSince(latestData!.timestamp)
            if timeDifference >= 60 {
                insert(data: data)
                
                if let name = FriendDatastore.shared?.fetchName(user_uid: user_uid) {
                    print("send pass notification")
                    NotificationManager().sendPassNotification(name: name)
                }
            }
                
        } catch {
            print("StreetPassData fetch error")
            print(error)
        }
    }
}
