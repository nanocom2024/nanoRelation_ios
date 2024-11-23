//
//  StatusViewModel.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/25.
//

import Foundation

actor StatusViewModel: ObservableObject {
    @Published var receivedHistory = NowStatus(pass: "false")
    @Published var receivedOtherHistory = NowStatus(pass: "false")
    @Published var errorString = ""
    
//    func received_beacon(info: BeaconInfo) async {
//        if info.proximity == "Unknown" {
//            return
//        }
//        do {
//            if let token = await Auth.getToken(),
//               let pass = try await request_received_beacon(token: token, major: info.major, minor: info.minor, latitude: info.latitude, longitude: info.longitude)
//            {
//                Task {
//                    let now = Date()
//                    let historyTimestamp = self.receivedOtherHistory.timestamp
//                    let timeDifference = now.timeIntervalSince(historyTimestamp)
//                    if pass == "lost" {
//                        self.receivedHistory = NowStatus(pass: pass)
//                        if self.receivedOtherHistory.pass != pass {
//                            self.receivedHistory = NowStatus(pass: pass)
//                        }
//                    } else if pass == "true" {
//                        // timestamp が10秒より前かを確認
//                        if timeDifference >= 10 {
//                            // 10秒以上前の場合の処理
//                            self.receivedHistory = NowStatus(pass: pass)
//                            self.receivedOtherHistory = NowStatus(pass: pass)
//                        }
//                    } else {
//                        // timestamp が10秒より前かを確認
//                        if timeDifference >= 10 {
//                            // 10秒以上前の場合の処理
//                            self.receivedHistory = NowStatus(pass: pass)
//                            self.receivedOtherHistory = NowStatus(pass: pass)
//                        }
//                    }
//                    
//                }
//            } else {
//                self.errorString = "err: beacon receive process"
//                print("err: beacon receive process")
//            }
//        } catch {
//            self.errorString = error.localizedDescription
//            print("Error: \(error.localizedDescription)")
//        }
//    }
    
    func received_beacon(info: BeaconInfo) async {
        if info.proximity == "Unknown" {
            return
        }

        if let pass = check_received_beacon(major: info.major, minor: info.minor, beaconMode: info.beaconMode) {
            Task {
                let now = Date()
                let historyTimestamp = self.receivedOtherHistory.timestamp
                let timeDifference = now.timeIntervalSince(historyTimestamp)
                if pass == "lost" {
                    self.receivedHistory = NowStatus(pass: pass)
                    if self.receivedOtherHistory.pass != pass {
                        self.receivedHistory = NowStatus(pass: pass)
                    }
                    await LostPassDatastore.shared?.received(major: info.major, minor: info.minor, latitude: info.latitude, longitude: info.longitude)
                } else if pass == "true" {
                    // timestamp が10秒より前かを確認
                    if timeDifference >= 10 {
                        // 10秒以上前の場合の処理
                        self.receivedHistory = NowStatus(pass: pass)
                        self.receivedOtherHistory = NowStatus(pass: pass)
                    }
                    await StreetPassDatastore.shared?.received(major: info.major, minor: info.minor)
                } else {
                    // timestamp が10秒より前かを確認
                    if timeDifference >= 10 {
                        // 10秒以上前の場合の処理
                        self.receivedHistory = NowStatus(pass: pass)
                        self.receivedOtherHistory = NowStatus(pass: pass)
                    }
                }
                
            }
        } else {
            self.errorString = "err: beacon receive process"
            print("err: beacon receive process")
        }
    }
    
    private func check_received_beacon(major: String, minor: String, beaconMode: BeaconMode) -> String? {
        // return "true", "false", "lost", nil
        
        if beaconMode == .lost {
            return "lost"
        }
        
        guard let user_uid = PairingDatastore.shared?.fetch_user_uid(major: major, minor: minor) else {
            return nil
        }
        
        let isExitFriend = FriendDatastore.shared?.isExistFriend(user_uid: user_uid)
        
        return isExitFriend == true ? "true" : "false"
    }
    
//    private func request_received_beacon(token: String, major: String, minor: String, latitude: Double?, longitude: Double?) async throws -> String? {
//        let url = URL(string: BaseUrl.url + "/streetpass/received_beacon")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let params = [
//            "token": token,
//            "received_major": major,
//            "received_minor": minor,
//            "latitude": latitude ?? 0.0,
//            "longitude": longitude ?? 0.0
//        ] as [String : Any]
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: params)
//        } catch {
//            print("Invalid JSON format.")
//            return nil
//        }
//        
//        let (data, _) = try await URLSession.shared.data(for: request)
//        
//        do {
//            if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//               let pass = object["pass"] as? String {
//                return pass
//            } else {
//                // server res -> err
//                Task {
//                    if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                       let err = object["error"] as? String {
//                        print(err)
//                    }
//                }
//                return nil
//            }
//        } catch {
//            //            print(error.localizedDescription)
//            throw error
//        }
//    }
}

struct NowStatus: Equatable {
    let pass: String
    let timestamp = Date()
}
