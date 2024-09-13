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
            if let (private_key, public_key, major, minor) = try await generate_major_minor(device_id: device_id) {
                let res = private_key + "," + public_key + "," + major + "," + minor
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
                print("return device info")
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

}
