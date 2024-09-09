//
//  DeleteView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/08.
//

import SwiftUI

struct DeleteView: View {
    @StateObject private var deleteViewModel = DeleteViewModel()
    @State private var inputPassword: String = ""
    @State private var inputConfirmPassword: String = ""
    @State private var errorMessage: String = ""
    @EnvironmentObject var navigationModel: NavigationModel
    
    var body: some View {
        VStack(alignment: .center) {
            if deleteViewModel.isLoading {
                ProgressView("delete...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                Spacer()
                
                Text("NanoRelation-ios")
                    .font(.system(size: 48,
                                  weight: .heavy))
                
                Text("DeleteView")
                    .font(.system(size: 40,
                                  weight: .heavy))
                
                if errorMessage != "" {
                    Spacer()
                    Text(errorMessage)
                        .foregroundStyle(Color.red)
                }

                VStack(spacing: 24) {
                    SecureField("password", text: $inputPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                    
                    SecureField("confirm password", text: $inputConfirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                }
                .frame(height: 200)

                Button(action: {
                    if inputPassword.isEmpty {
                        errorMessage = "Missing password"
                        return
                    }
                    if inputConfirmPassword.isEmpty {
                        errorMessage = "Missing confirmPassword"
                        return
                    }
                    if inputPassword != inputConfirmPassword {
                        errorMessage = "Passwords do not match"
                        return
                    }
                    deleteViewModel.delete_account(password: inputPassword, confirmPassword: inputConfirmPassword)
                },
                label: {
                    Text("Delete Account")
                        .fontWeight(.medium)
                        .frame(minWidth: 160)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.red)
                        .cornerRadius(8)
                })
                
                Spacer()
            }
            
        }
        .onChange(of: deleteViewModel.deleteSuccess) { _, success in
            if success {
                // Navigate back to root
                navigationModel.path.removeLast(navigationModel.path.count)
            }
        }
        .onChange(of: deleteViewModel.errorMessage ?? "") { _, msg in
            if msg.isEmpty {
                errorMessage = msg
            }
        }
    }
}

#Preview {
    DeleteView()
}
