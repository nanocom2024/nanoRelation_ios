//
//  EachChildViewModel.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/20.
//

import Foundation
import SwiftUI

class EachChildViewModel: ObservableObject {
    @Published var errorString = ""
    
    func isLost(uid: String) async -> Bool? {
        do {
            let res = try await fetch_isLost(uid: uid)
            return res
        } catch {
            DispatchQueue.main.async {
                self.errorString = error.localizedDescription
            }
            return nil
        }
    }
    
    private func fetch_isLost(uid: String) async throws -> Bool? {
        let url = URL(string: BaseUrl.url + "/lost_child/isLost")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = ["uid": uid]
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
        
        do {
            if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let is_lost = object["is_lost"] as? String {
                    
                    if is_lost == "true" {
                        return true
                    } else if is_lost == "false" {
                        return false
                    }
                    
                } else if let errStr = object["error"] as? String {
                    DispatchQueue.main.async {
                        self.errorString = errStr
                    }
                    return nil
                }
            }
            DispatchQueue.main.async {
                self.errorString = "API response does not match the expected format."
            }
            return nil
        } catch {
            //            print(error.localizedDescription)
            throw error
        }
    }
    
    
    func register_lost(child_uid: String) async -> Bool? {
        do {
            guard let token = Auth.getToken() else {
                DispatchQueue.main.async {
                    self.errorString = "missing token"
                }
                return nil
            }
            let res = try await register_lost_request(parent_token: token, child_uid: child_uid)
            return res
        } catch {
            DispatchQueue.main.async {
                self.errorString = error.localizedDescription
            }
            return nil
        }
    }
    
    private func register_lost_request(parent_token: String, child_uid: String) async throws -> Bool? {
        let url = URL(string: BaseUrl.url + "/lost_child/register_lost")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = ["token": parent_token, "uid": child_uid]
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
        
        do {
            if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let done = object["done"] as? String {
                    
                    if done == "Lost child registered" {
                        return true
                    }
                    
                } else if let errStr = object["error"] as? String {
                    DispatchQueue.main.async {
                        self.errorString = errStr
                    }
                    return nil
                }
            }
            DispatchQueue.main.async {
                self.errorString = "API response does not match the expected format."
            }
            return nil
        } catch {
            //            print(error.localizedDescription)
            throw error
        }
    }
    
    
    func delete_lost_info(child_uid: String) async -> Bool? {
        do {
            guard let token = Auth.getToken() else {
                DispatchQueue.main.async {
                    self.errorString = "missing token"
                }
                return nil
            }
            let res = try await delete_lost_info_request(parent_token: token, child_uid: child_uid)
            return res
        } catch {
            DispatchQueue.main.async {
                self.errorString = error.localizedDescription
            }
            return nil
        }
    }
    
    private func delete_lost_info_request(parent_token: String, child_uid: String) async throws -> Bool? {
        let url = URL(string: BaseUrl.url + "/lost_child/delete_lost_info")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = ["token": parent_token, "uid": child_uid]
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
        
        do {
            if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let done = object["done"] as? String {
                    
                    if done == "Lost child deleted" {
                        return true
                    }
                    
                } else if let errStr = object["error"] as? String {
                    DispatchQueue.main.async {
                        self.errorString = errStr
                    }
                    return nil
                }
            }
            DispatchQueue.main.async {
                self.errorString = "API response does not match the expected format."
            }
            return nil
        } catch {
            //            print(error.localizedDescription)
            throw error
        }
    }
    
    
    func addMsg(child_uid: String, newMsg: Message) async -> Bool? {
        do {
            guard let token = Auth.getToken() else {
                DispatchQueue.main.async {
                    self.errorString = "missing token"
                }
                return nil
            }
            let res = try await addMsg_request(parent_token: token, child_uid: child_uid, newMsg: newMsg)
            return res
        } catch {
            DispatchQueue.main.async {
                self.errorString = error.localizedDescription
            }
            return nil
        }
    }
    
    private func addMsg_request(parent_token: String, child_uid: String, newMsg: Message) async throws -> Bool? {
        let url = URL(string: BaseUrl.url + "/lost_child/add_message")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = [
            "token": parent_token,
            "uid": child_uid, 
            "msgID": newMsg.id.uuidString,
            "tag": newMsg.tag,
            "text": newMsg.text,
            "timestamp": newMsg.date.timeIntervalSince1970
        ] as [String : Any]
        
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
        
        do {
            if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let done = object["done"] as? String {
                    
                    if done == "Message added" {
                        return true
                    }
                    
                } else if let errStr = object["error"] as? String {
                    DispatchQueue.main.async {
                        self.errorString = errStr
                    }
                    return nil
                }
            }
            DispatchQueue.main.async {
                self.errorString = "API response does not match the expected format."
            }
            return nil
        } catch {
            //            print(error.localizedDescription)
            throw error
        }
    }
    
    
    func getMessages(child_uid: String) async -> [Message] {
        do {
            var res: [Message] = []
            let messagesResponse = try await fetch_messages(child_uid: child_uid)
            for msg in messagesResponse?.messages ?? [] {
                guard let uuid = UUID(uuidString: msg.msgID) else {
                    print("not expected uuid")
                    continue
                }
                var color: Color
                switch msg.tag {
                case "start":
                    color = .red
                case "end":
                    color = .blue
                default:
                    print("not expected tag")
                    continue
                }
                let date = Date(timeIntervalSince1970: msg.timestamp)
                let one_msg = Message(id: uuid, tag: msg.tag, text: msg.text, color: color, date: date)
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
    
    
    private func fetch_messages(child_uid: String) async throws -> MessagesResponse? {
        let url = URL(string: BaseUrl.url + "/lost_child/fetch_messages")!
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
        let params = ["token": token, "uid": child_uid]
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
        let response = try JSONDecoder().decode(MessagesResponse.self, from: data)
        return response
    }
}

struct MessagesResponse: Codable {
    let messages: [MsgResponse]
}

struct MsgResponse: Codable {
    let msgID: String
    let tag: String
    let text: String
    let timestamp: Double
}
