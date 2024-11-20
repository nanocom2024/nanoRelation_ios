//
//  Paring.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/20.
//

import Foundation
import SwiftData

@Model
class Pairing {
    var id: UUID
    var device_uid: String
    var major: String
    var minor: String
    
    init(device_uid: String, major: String, minor: String) {
        self.id = UUID()
        self.device_uid = device_uid
        self.major = major
        self.minor = minor
    }
}

class PairingDatastore {
    @MainActor static let shared = PairingDatastore()
    
    var container: ModelContainer
    private var context: ModelContext
    
    private init?() {
        let fileName = "Pairing"
        let sqliteURL = URL.documentsDirectory
          .appending(component: fileName)
          .appendingPathExtension("sqlite")
        
        // 1. Model 定義の型情報で Schema を初期化
        let schema = Schema([Pairing.self])
        // 2. Schema で ModelConfiguration を初期化
        let modelConfiguration = ModelConfiguration(schema: schema, url: sqliteURL)
        do {
            // 3. ModelConfiguration で ModelContainer で初期化
            let modelContainer = try ModelContainer(
                for: Pairing.self,
                configurations: modelConfiguration
            )
            self.container = modelContainer
            // 4. ModelContainer で ModelContext で初期化
            self.context = ModelContext(modelContainer)
        } catch {
            print("Failed to initialize AuthTokenDatastore.")
            print(error)
            return nil
        }
    }
    
    
    func insert(data: Pairing) {
        do {
            context.insert(data)
            try context.save()
        } catch {
            print("pairing insert error")
            print(error)
        }
    }
    
    func fetchAll() -> [Pairing] {
        do {
            let pairings = try context.fetch(FetchDescriptor<Pairing>())
            return pairings
        } catch {
            print("pairing fetch error")
            print(error)
        }
        return []
    }
    
    func deleteAll() {
        do {
            let pairings = try context.fetch(FetchDescriptor<Pairing>())
            for pairing in pairings {
                context.delete(pairing)
            }
            try context.save()
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func syncPairings() {
        Task {
            do {
                guard let pairings: [Pairing] = await CloudPairingsDatastore().fetchPairings() else {
                    return
                }
                
                // transaction
                try context.transaction {
                    
                    do {
                        // delete all
                        for pairing in try context.fetch(FetchDescriptor<Pairing>()) {
                            context.delete(pairing)
                        }
                        print("delete all", try context.fetch(FetchDescriptor<Pairing>()).count)
                        
                        // insert all
                        for pairing in pairings {
                            context.insert(pairing)
                        }
                        print("insert all", pairings.count)
                    } catch {
                        print("syncPairings error")
                        print(error)
                        throw error
                    }
                    
                }
            } catch {
                print("syncPairings error")
                print(error)
            }
        }
    }
            
}

class CloudPairingsDatastore {
    func fetchPairings() async -> [Pairing]? {
        do {
            var res: [Pairing] = []
            let PairingsResponse = try await fetch_pairings()
            for pairing in PairingsResponse?.pairings ?? [] {
                let one_pairing = Pairing(device_uid: pairing.uid, major: pairing.major, minor: pairing.minor)
                res.append(one_pairing)
            }
            return res
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    private func fetch_pairings() async throws -> PairingsResponse? {
        let url = URL(string: BaseUrl.url + "/pairing/fetch_pairings")!
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
        let response = try JSONDecoder().decode(PairingsResponse.self, from: data)
        return response
    }
    
    
    struct PairingsResponse: Codable {
        let pairings: [Response]
    }

    struct Response: Codable {
        let uid: String
        let major: String
        let minor: String
    }
}
