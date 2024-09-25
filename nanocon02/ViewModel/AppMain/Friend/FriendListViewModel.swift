//
//  FriendListViewModel.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/23.
//

import Foundation

class FriendListViewModel: ObservableObject {
    @Published var errorString = ""
    
    func get_users() async -> [Friend] {
        do {
            var res: [Friend] = []
            let usersResponse = try await fetch_users()
            for user in usersResponse?.users ?? [] {
                let one_user = Friend(id: user.uid, name: user.name, name_id: user.name_id)
                res.append(one_user)
            }
            return res
        } catch {
            DispatchQueue.main.async {
                self.errorString = error.localizedDescription
            }
            return []
        }
    }
    
    
    private func fetch_users() async throws -> UsersResponse? {
        let url = URL(string: BaseUrl.url + "/user/fetch_users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = Auth.getToken() else {
            DispatchQueue.main.async {
                self.errorString = "missing token"
            }
            print("missing token")
            return nil
        }
        let params = ["token": token]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        } catch {
            DispatchQueue.main.async {
                self.errorString = "Invalid JSON format."
            }
            print("Invalid JSON format.")
            return nil
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(UsersResponse.self, from: data)
        return response
    }
}

struct UsersResponse: Codable {
    let users: [UserResponse]
}

struct UserResponse: Codable {
    let uid: String
    let name: String
    let name_id: String
}
