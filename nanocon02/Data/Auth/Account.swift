//
//  Account.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/18.
//

import Foundation

class Account{
    static var name: String = "no-name"
    
    static func get_name() async -> String {
        guard let token = Auth.getToken() else {
            Account.name = "no-name"
            print("missing token")
            return Account.name
        }
        do {
            if let name = try await Account.fetch_name(token: token) {
                Account.name = name
                return name
            }
        } catch {
            print(error.localizedDescription)
        }
        return Account.name
    }
    
    private static func fetch_name(token: String) async throws -> String? {
        let url = URL(string: BaseUrl.url + "/auth/fetch_name")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = ["token": token]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        } catch {
            print("Invalid JSON format.")
            return nil
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let name = object["name"] as? String {
                return name
            } else {
//                print("Pairing fail")
                return nil
            }
        } catch {
//            print(error.localizedDescription)
            throw error
        }

    }
}
