//
//  MyChildrenListViewModel.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/19.
//

import Foundation

class MyChildrenListViewModel: ObservableObject {
    @Published var errorString = ""
    
    func getChildren() async -> [Child] {
        do {
            var res: [Child] = []
            let childrenResponse = try await fetch_children()
            for child in childrenResponse?.children ?? [] {
                let one_child = Child(id: child.uid, name: child.name, name_id: child.name_id)
                res.append(one_child)
            }
            return res
        } catch {
            DispatchQueue.main.async {
                self.errorString = error.localizedDescription
            }
            return []
        }
    }
    
    
    private func fetch_children() async throws -> ChildrenResponse? {
        let url = URL(string: BaseUrl.url + "/child/fetch_children")!
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
        let response = try JSONDecoder().decode(ChildrenResponse.self, from: data)
        return response
    }
}

struct ChildrenResponse: Codable {
    let children: [ChildResponse]
}

struct ChildResponse: Codable {
    let uid: String
    let name: String
    let name_id: String
}
