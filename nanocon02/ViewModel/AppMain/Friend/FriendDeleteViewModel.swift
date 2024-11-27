//
//  FriendDeleteViewModel.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/24.
//

import Foundation

actor FriendDeleteViewModel: ObservableObject {
    @Published var errorString = ""
    
    func deleteFriend(friend_uid: String, name_id: String) async -> Bool {
        // success: return true, fail: return false
        
        do {
            let res = try await delete_request(friend_uid: friend_uid, name_id: name_id)
            if res {
                await FriendDatastore.shared?.delete(user_uid: friend_uid, name_id: name_id)
                return true
            }
            return false
        } catch {
            self.errorString = error.localizedDescription
            return false
        }
    }
    
    private func delete_request(friend_uid: String, name_id: String) async throws -> Bool {
        // success: return true, fail: return false
        
        let url = URL(string: BaseUrl.url + "/friend/delete_request")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = await Auth.getToken() else {
            self.errorString = "missing token"
            print("missing token")
            return false
        }
        let params = ["token": token, "friend_uid": friend_uid, "name_id": name_id]
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
