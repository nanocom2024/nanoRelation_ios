//
//  EachFriendViewModel.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/24.
//

import Foundation
import SwiftUI

class EachFriendViewModel: ObservableObject {
    @Published var errorString = ""
    
    func getMessages(uid: String) async -> [Message] {
        do {
            var res: [Message] = []
            let logsResponse = try await fetch_logs(uid: uid)
            for log in logsResponse?.logs ?? [] {
                var text: String
                var color: Color
                switch log.tag {
                case "own":
                    text = "デバイスは近くにあります"
                    color = .green
                case "child":
                    text = "近くにいます"
                    color = .green
                case "lost":
                    text = "迷子とすれ違いました"
                    color = .yellow
                case "pass":
                    text = "すれ違いました"
                    color = .blue
                default:
                    print("not expected tag")
                    continue
                }
                let date = Date(timeIntervalSince1970: log.timestamp)
                let one_msg = Message(tag: log.tag, text: text, color: color, date: date)
                res.append(one_msg)
            }
            return res
        } catch {
            DispatchQueue.main.async {
                self.errorString = error.localizedDescription
            }
            return []
        }
    }
    
    
    private func fetch_logs(uid: String) async throws -> LogsResponse? {
        let url = URL(string: BaseUrl.url + "/user/fetch_user_log")!
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
        let params = ["token": token, "uid": uid]
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
        let response = try JSONDecoder().decode(LogsResponse.self, from: data)
        return response
    }
    
    
    struct LogsResponse: Codable {
        let logs: [OneLogResponse]
    }

    struct OneLogResponse: Codable {
        let tag: String
        let timestamp: Double
    }
}
