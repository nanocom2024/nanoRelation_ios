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
                
                Text("アカウントを削除")
                    .font(.system(size: 40,
                                  weight: .heavy))
                
//                Text("DeleteView")
//                    .font(.system(size: 40,
//                                  weight: .heavy))
                
                if errorMessage != "" {
//                    Spacer()
                    Text(errorMessage)
                        .foregroundStyle(Color.red)
                        .frame(width: 300, height: 10) // 幅と高さを固定
                }

                VStack{
                    Text("パスワード")
                        .font(.system(size: 20,
                                      weight: .semibold))
                        .frame(maxWidth: 280, alignment: .leading)
                        .padding(0)
                    
                    TextField("Password", text: $inputPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                        .padding(.top,-10)
                        .padding(.bottom,10)
                    
                    Text("確認用パスワード")
                        .font(.system(size: 20,
                                      weight: .semibold))
                        .frame(maxWidth: 280, alignment: .leading)
                        .padding(0)
                    
                    TextField("ConfirmPassword", text: $inputConfirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                        .padding(.top,-10)
                        .padding(.bottom,10)
                    
                }
                .frame(height: 200)

                Button(action: {
                    if inputPassword.isEmpty {
                        errorMessage = "パスワードを入力してください"
                        return
                    }
                    if inputConfirmPassword.isEmpty {
                        errorMessage = "確認用パスワードを入力してください"
                        return
                    }
                    if inputPassword != inputConfirmPassword {
                        errorMessage = "パスワードが一致していません"
                        return
                    }
                    deleteViewModel.delete_account(password: inputPassword, confirmPassword: inputConfirmPassword)
                },
                label: {
                    Text("アカウント削除")
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
            if !msg.isEmpty {
                errorMessage = msg
            }
        }
    }
}

#Preview {
    DeleteView()
}
