//
//  FriendAddViewModel.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/24.
//

import Foundation

actor FriendAddViewModel: ObservableObject {
    @Published var errorString = ""
    
    func addFriend(code: String) async -> Bool {
        do {
            let res = try await add_request(code: code)
            return res
        } catch {
            self.errorString = error.localizedDescription
            return false
        }
    }
    
    private func add_request(code: String) async throws -> Bool {
        let url = URL(string: BaseUrl.url + "/friend/add_request")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = await Auth.getToken() else {
            self.errorString = "missing token"
            print("missing token")
            return false
        }
        let params = ["token": token, "code": code]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        } catch {
            self.errorString = "Invalid JSON format."
            print("Invalid JSON format.")
            return false
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(DataResponse.self, from: data)
        if response.done == "success" {
            return true
        } else {
            self.errorString = response.error ?? "Unknown error"
            print(response.error ?? "Unknown error")
        }
            
        return false
    }
    
    struct DataResponse: Codable {
        let done: String?
        let error: String?
    }

}
