//
//  TestViewModel.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/08.
//

import Foundation

class TestViewModel: ObservableObject {
    func signout() {
        let url = URL(string: BaseUrl.url + "/auth/signout")!
        var request = URLRequest(url: url)
        // Postリクエストを送る(このコードがないとGetリクエストになる)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var params = Dictionary<String, String>()
        guard let token = Auth.getToken() else {
            print("Invalid token")
            return
        }
        params["token"] = token
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        }catch{
            print("Invalid JSON format.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("No data received.")
                return
            }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            do {
                // JSONデータを辞書形式に変換
                if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let done = object["done"] as? String {
                    if done == "success" {
                        Auth.deleteToken()
                        return
                    } else {
                        print("signout fail")
                        return
                    }
                } else {
                    print("signout fail")
                    return
                }
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        task.resume()

    }
}
