//
//  AuthToken.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/20.
//

import Foundation
import SwiftData

@Model
class AuthToken {
    @Attribute(.unique)
    var id: UUID
    var token: String
    var user_uid: String
    
    init(token: String, user_uid: String) {
        self.id = UUID()
        self.token = token
        self.user_uid = user_uid
    }
}

class AuthTokenDatastore {
    @MainActor static let shared = AuthTokenDatastore()
    
    private var context: ModelContext
    
    private init?() {
        let fileName = "AuthToken"
        let sqliteURL = URL.documentsDirectory
          .appending(component: fileName)
          .appendingPathExtension("sqlite")
        
        // 1. Model 定義の型情報で Schema を初期化
        let schema = Schema([AuthToken.self])
        // 2. Schema で ModelConfiguration を初期化
        let modelConfiguration = ModelConfiguration(schema: schema, url: sqliteURL)
        do {
            // 3. ModelConfiguration で ModelContainer で初期化
            let modelContainer = try ModelContainer(
                for: AuthToken.self,
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
    
    
    func getToken() -> String {
        do {
            
            let token = try context.fetch(FetchDescriptor<AuthToken>())
            if token.isEmpty {
                return ""
            } else {
                return token[0].token
            }
            
        } catch {
            return ""
        }
    }
    
    func getUserUid() -> String {
        do {
            
            let token = try context.fetch(FetchDescriptor<AuthToken>())
            if token.isEmpty {
                return ""
            } else {
                return token[0].user_uid
            }
            
        } catch {
            return ""
        }
    }
        
    
    func setToken(token: String, user_uid: String) {
        do {
            deleteToken()
            
            let newToken = AuthToken(token: token, user_uid: user_uid)
            context.insert(newToken)
            try context.save()
        } catch {
            print("settoken error")
            print(error)
        }
    }
    
    func deleteToken() {
        do {
            let tokens = try context.fetch(FetchDescriptor<AuthToken>())
            for token in tokens {
                context.delete(token)
            }
            try context.save()
        } catch {
            print(error)
        }
    }
            
}
