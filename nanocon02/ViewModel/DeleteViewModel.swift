//
//  DeleteViewModel.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/08.
//

import Foundation

class DeleteViewModel: ObservableObject {
    @Published var deleteSuccess = false
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    func delete_account(password: String, confirmPassword: String) {
        self.isLoading = true
        self.deleteSuccess = false
        
        let url = URL(string: BaseUrl.url + "/auth/delete_account")!
        var request = URLRequest(url: url)
        // Postリクエストを送る(このコードがないとGetリクエストになる)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var params = Dictionary<String, String>()
        guard let token = Auth.getToken() else {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Invalid token"
            }
            print("Invalid token")
            return
        }
        params["token"] = token
        params["password"] = password
        params["confirmPassword"] = confirmPassword
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
                   let done = object["done"] as? String {
                    
                    if done != "success" {
                        print("Delete fail")
                        return
                    }
                    
                    // クッキーを削除
                    Auth.deleteToken()
                    
                    // 成功を通知
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.deleteSuccess = true
                        self.errorMessage = nil
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.errorMessage = "Delete fail"
                    }
                    print("Delete fail")
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
