//
//  SignupViewModel.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/08.
//

import Foundation

class SignupViewModel: ObservableObject {
    @Published var signupSuccess = false
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    func signup(name: String, email: String, password: String) {
        self.isLoading = true
        self.signupSuccess = false
        
        let url = URL(string: BaseUrl.url + "/auth/signup")!
        var request = URLRequest(url: url)
        // Postリクエストを送る(このコードがないとGetリクエストになる)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var params = Dictionary<String, String>()
        params["name"] = name
        params["email"] = email
        params["password"] = password
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
                   let token = object["token"] as? String { // トークンを取得
                        
                    // クッキーを設定
                    Auth.setToken(token: token)
                    
                    // 成功を通知
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.signupSuccess = true
                        self.errorMessage = nil
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.errorMessage = "Invalid login credentials."
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

