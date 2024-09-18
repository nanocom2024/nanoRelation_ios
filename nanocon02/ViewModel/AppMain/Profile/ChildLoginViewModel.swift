//
//  ChildLoginViewModel.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/17.
//

import Foundation

class ChildLoginViewModel: ObservableObject {
    @Published var loginSuccess = false
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    // TODO: signin -> register child
    func register_child(email: String, password: String) {
        self.isLoading = true
        self.loginSuccess = false
        
        guard let token = Auth.getToken() else {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "missing token"
            }
            return
        }
        
        let url = URL(string: BaseUrl.url + "/child/register_child")!
        var request = URLRequest(url: url)
        // Postリクエストを送る(このコードがないとGetリクエストになる)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let params = ["token": token, "email": email, "password": password]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        }catch{
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Invalid JSON format."
            }
            print("Invalid JSON format.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "No data received."
                }
                print("No data received.")
                return
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
                print(error.localizedDescription)
                return
            }
            
            do {
                // JSONデータを辞書形式に変換
                if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let done = object["done"] as? String,
                        done == "register" {
                    
                    // 成功を通知
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.loginSuccess = true
                        self.errorMessage = nil
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.errorMessage = "Invalid login credentials."
                    }
                    Task {
                        if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let err = object["error"] as? String {
                            print(err)
                        }
                    }
                    print("Invalid login credentials.")
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

