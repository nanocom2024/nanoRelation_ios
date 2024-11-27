//
//  LostInfoViewModel.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/26.
//

import Foundation

actor LostInfoViewModel: ObservableObject {
    @Published var errorString = ""
    
    func getLostInfo() async -> [LostInfo]? {
        do {
            var res: [LostInfo] = []
            let infoResponse = try await fetch_info()
            for info in infoResponse?.info ?? [] {
                let date = Date(timeIntervalSince1970: info.timestamp)
                let one_info = LostInfo(latitude: info.latitude, longitude: info.longitude, timestamp: date)
                res.append(one_info)
            }
            return res
        } catch {
            self.errorString = error.localizedDescription
            return []
        }
    }
    
    
    private func fetch_info() async throws -> LostInfoResponse? {
        let url = URL(string: BaseUrl.url + "/lost_child/fetch_info")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = await Auth.getToken() else {
            self.errorString = "missing token"
            print("missing token")
            return nil
        }
        let params = ["token": token]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        } catch {
            self.errorString = "Invalid JSON format."
            print("Invalid JSON format.")
            return nil
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(LostInfoResponse.self, from: data)
        return response
    }
    
    
    struct LostInfoResponse: Codable {
        let info: [Response]
    }
    
    struct Response: Codable {
        let latitude: Double
        let longitude: Double
        let timestamp: Double
    }
}
