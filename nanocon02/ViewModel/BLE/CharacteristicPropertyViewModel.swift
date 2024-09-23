//
//  CharacteristicPropertyViewModel.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/12.
//

import Foundation

class CharacteristicPropertyViewModel: ObservableObject {
    @Published var errorString = ""
    
    func generate_writeString(device_id: String) async -> String? {
        do {
            if let (_, _, major, minor) = try await generate_major_minor(device_id: device_id),
               let token = Auth.getToken(),
               try await register_pairing(token: token, major: major, minor: minor)
            {
//                let res = private_key + "," + public_key + "," + major + "," + minor
                let res = major + "," + minor
                return res
            } else {
                DispatchQueue.main.async {
                    self.errorString = "Pairing fail"
                }
                print("Pairing fail")
            }
        } catch {
            DispatchQueue.main.async {
                self.errorString = error.localizedDescription
            }
            print("Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    private func generate_major_minor(device_id: String) async throws -> (String, String, String, String)? {
        let url = URL(string: BaseUrl.url + "/pairing/generate_major_minor")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = ["uid": device_id]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        } catch {
            print("Invalid JSON format.")
            return nil
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let private_key = object["private_key"] as? String,
               let public_key = object["public_key"] as? String,
               let major = object["major"] as? String,
               let minor = object["minor"] as? String {
                return (private_key, public_key, major, minor)
            } else {
//                print("Pairing fail")
                return nil
            }
        } catch {
//            print(error.localizedDescription)
            throw error
        }
    }

    private func register_pairing(token: String, major: String, minor: String) async throws -> Bool {
        let url = URL(string: BaseUrl.url + "/pairing/register_pairing")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = ["token": token, "major": major, "minor": minor]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        } catch {
            print("Invalid JSON format.")
            return false
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let done = object["done"] as? String {
                return done == "pairing"
            } else {
                // server res -> err
                Task {
                    if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let err = object["error"] as? String {
                        print(err)
                    }
                }
                print("register fail")
                return false
            }
        } catch {
//            print(error.localizedDescription)
            throw error
        }
    }
}
