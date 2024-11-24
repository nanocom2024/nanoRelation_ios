//
//  MyQrCodeViewModel.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/24.
//

import Foundation

actor MyQrCodeViewModel: ObservableObject {
    @Published var errorString = ""
    
    func getData() async -> String? {
        do {
            let dataResponse = try await fetch_data()
            return dataResponse?.data
        } catch {
            self.errorString = error.localizedDescription
            return nil
        }
    }
    
    
    private func fetch_data() async throws -> DataResponse? {
        let url = URL(string: BaseUrl.url + "/friend/fetch_qr_data")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = await Auth.getToken() else {
            self.errorString = "missing token"
            print("missing token")
            return nil
        }
        let params = ["token": token]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        } catch {
            self.errorString = "Invalid JSON format."
            print("Invalid JSON format.")
            return nil
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(DataResponse.self, from: data)
        return response
    }
    
    
    struct DataResponse: Codable {
        let data: String
    }

}
