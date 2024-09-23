//
//  StreetPassViewModel.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/14.
//

import Foundation

class StreetPassViewModel: ObservableObject {
    @Published var receivedHistory = ""
    @Published var errorString = ""

    func received_beacon(info: BeaconInfo) async {
        if info.proximity == "Unknown" {
            return
        }
        do {
            if let token = Auth.getToken(),
               let pass = try await request_received_beacon(token: token, major: info.major, minor: info.minor)
            {
                let currentDate = Date()  // Date型
                let dateString = StreetPassViewModel.dateFormatter.string(from: currentDate)  // String型に変換
                DispatchQueue.main.async {
                    self.receivedHistory = dateString + pass
                }
            } else {
                DispatchQueue.main.async {
                    self.errorString = "err: beacon receive process"
                }
                print("err: beacon receive process")
            }
        } catch {
            DispatchQueue.main.async {
                self.errorString = error.localizedDescription
            }
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "[yyyy-MM-dd HH:mm:ss] "
        return formatter
    }()


    private func request_received_beacon(token: String, major: String, minor: String) async throws -> String? {
        let url = URL(string: BaseUrl.url + "/streetpass/received_beacon")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let params = ["token": token, "received_major": major, "received_minor": minor]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        } catch {
            print("Invalid JSON format.")
            return nil
        }

        let (data, _) = try await URLSession.shared.data(for: request)

        do {
            if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let pass = object["pass"] as? String {
                return pass
            } else {
                // server res -> err
                Task {
                    if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let err = object["error"] as? String {
                        print(err)
                    }
                }
                return nil
            }
        } catch {
            //            print(error.localizedDescription)
            throw error
        }
    }
}
