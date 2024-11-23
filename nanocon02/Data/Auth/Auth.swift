//
//  Auth.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/08.
//

import Foundation
import SwiftData

class Auth {
    @MainActor static private let cookieManager = CookieManager()
    static private let url = URL(string: BaseUrl.url + "/auth")!

//    @MainActor static func getToken() -> String? {
//        if cookieManager.isCookieSet(name: "authtoken", url: url) {
//            return cookieManager.getCookie(name: "authtoken", url: url)
//        }
//        return nil
//    }
    @MainActor static func getToken() -> String? {
        let token = AuthTokenDatastore.shared?.getToken()
        if token == "" {
            return nil
        }
        return token
    }

//    @MainActor static func setToken(token: String) {
//        cookieManager.setCookie(url: url, key: "authtoken", value: token)
//        AppDelegate.storeCookies()
//        Account.name = "no-name"
//        Account.name_id = "#xxxx"
//    }
    @MainActor static func setToken(token: String, user_uid: String, name: String, name_id: String) {
        AuthTokenDatastore.shared?.setToken(token: token, user_uid: user_uid, name: name, name_id: name_id)
        Account.name = "no-name"
        Account.name_id = "#xxxx"
    }
        

    @MainActor static func deleteToken() {
        cookieManager.removeCookie(name: "authtoken", url: url)
    }

    @MainActor static func auth_check(completion: @escaping (Bool) -> Void){
        var done = false
        let auth_check_url = URL(string: BaseUrl.url + "/pairing/auth_check")!
        var request = URLRequest(url: auth_check_url)
        // Postリクエストを送る(このコードがないとGetリクエストになる)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var params = Dictionary<String, String>()
        guard let token = getToken() else {
            print("token is not found")
            done = true
            completion(false)
            return
        }
        params["token"] = token

        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        }catch{
            print("Invalid JSON format.")
            done = true
            completion(false)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("No data received.")
                done = true
                completion(false)
                return
            }

            if let error = error {
                print(error.localizedDescription)
                done = true
                completion(false)
                return
            }

            do {
                // JSONデータを辞書形式に変換
                if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = object["token"] as? String,
                   let user_uid = object["user_uid"] as? String,
                   let name = object["name"] as? String,
                   let name_id = object["name_id"] as? String {
                    // クッキーを設定
                    Task {
                        await Auth.setToken(token: token, user_uid: user_uid, name: name, name_id: name_id)
                    }
                    done = true
                    completion(true)
                } else {
                    print("Invalid login credentials.")
                    done = true
                    completion(false)
                }
            } catch let error {
                print(error.localizedDescription)
                done = true
                completion(false)
            }

            if !done {
                print("cannot done")
                completion(false)
            }
        }
        task.resume()
    }
}
