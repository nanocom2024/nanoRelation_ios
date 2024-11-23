//
//  LostPass.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/23.
//

import Foundation
import SwiftData

@Model
class LostPassData {
    @Attribute(.unique)
    var id: UUID
    var major: String
    var minor: String
    var latitude: Double? // 緯度
    var longitude: Double? // 経度
    var timestamp: Date
    
    init(major: String, minor: String, latitude: Double? = nil, longitude: Double? = nil) {
        self.id = UUID()
        self.major = major
        self.minor = minor
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = Date()
    }
}

class LostPassDatastore {
    @MainActor static let shared = LostPassDatastore()
    
    private var context: ModelContext
    
    private init?() {
        let fileName = "LostPass"
        let sqliteURL = URL.documentsDirectory
          .appending(component: fileName)
          .appendingPathExtension("sqlite")
        
        // 1. Model 定義の型情報で Schema を初期化
        let schema = Schema([LostPassData.self])
        // 2. Schema で ModelConfiguration を初期化
        let modelConfiguration = ModelConfiguration(schema: schema, url: sqliteURL)
        do {
            // 3. ModelConfiguration で ModelContainer で初期化
            let modelContainer = try ModelContainer(
                for: LostPassData.self,
                configurations: modelConfiguration
            )
            // 4. ModelContainer で ModelContext で初期化
            self.context = ModelContext(modelContainer)
        } catch {
            print("Failed to initialize LostPassDatastore.")
            print(error)
            return nil
        }
    }
    
    
    func insert(data: LostPassData) {
        do {
            context.insert(data)
            try context.save()
        } catch {
            print("LostPassData insert error")
            print(error)
        }
    }
    
    func fetchAll() -> [LostPassData] {
        do {
            let data = try context.fetch(FetchDescriptor<LostPassData>())
            if data.isEmpty {
                return []
            }
            return data
        } catch {
            print("LostPassData fetch error")
            print(error)
        }
        return []
    }

    @MainActor func received(major: String, minor: String, latitude: Double? = nil, longitude: Double? = nil) {
        let data = LostPassData(major: major, minor: minor, latitude: latitude, longitude: longitude)
        do {
            let allData = try context.fetch(FetchDescriptor<LostPassData>(
                predicate: #Predicate{$0.major == major && $0.minor == minor}
            ))
            if allData.isEmpty {
                insert(data: data)
                
                print("send lostPass notification")
                NotificationManager().sendLostPassNotification()
                return
            }
            
            let latestData = allData.sorted(by: { $0.timestamp > $1.timestamp }).first
            let date = Date()
            let timeDifference = date.timeIntervalSince(latestData!.timestamp)
            if timeDifference >= 30 {
                insert(data: data)
                
                print("send lostPass notification")
                NotificationManager().sendLostPassNotification()
            }
                
        } catch {
            print("LostPassData fetch error")
            print(error)
        }
    }
}
