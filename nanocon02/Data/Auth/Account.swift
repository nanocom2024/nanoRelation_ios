//
//  Account.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/18.
//

import Foundation

class Account{
    static var name: String = "no-name"
    static var name_id: String = "#xxxx"
    
    static func get_name() async -> (String, String) {
        guard let token = Auth.getToken() else {
            Account.name = "no-name"
            Account.name_id = "#xxxx"
            print("missing token")
            return (Account.name, Account.name_id)
        }
        do {
            if let (name, name_id) = try await Account.fetch_name(token: token) {
                Account.name = name
                Account.name_id = name_id
                return (name, name_id)
            }
        } catch {
            print(error.localizedDescription)
        }
        return (Account.name, Account.name_id)
    }
    
    private static func fetch_name(token: String) async throws -> (String, String)? {
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
               let name = object["name"] as? String,
               let name_id = object["name_id"] as? String {
                return (name, name_id)
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
