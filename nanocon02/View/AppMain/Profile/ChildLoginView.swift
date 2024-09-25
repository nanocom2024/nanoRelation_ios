//
//  ChildLoginView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/17.
//

import SwiftUI

struct ChildLoginView: View {
    @StateObject private var childLoginViewModel = ChildLoginViewModel()
    @State private var inputEmail: String = ""
    @State private var inputPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoginButtonDisabled = false
    @EnvironmentObject private var navigationModel: NavigationModel
    
    var body: some View {
        Group {
            if childLoginViewModel.isLoading {
                VStack(alignment: .center) {
                    ProgressView("Logging in...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    
                    Text("子供を追加する")
                        .font(.system(size: 40,
                                      weight: .heavy))
                    
                    if errorMessage != "" {
                        Spacer()
                        Text(errorMessage)
                            .foregroundStyle(Color.red)
                            .frame(width: 300, height: 10)
                    }
                    
                    VStack {
                        Text("メールアドレス")
                            .font(.system(size: 20,
                                          weight: .semibold))
                            .frame(maxWidth: 280, alignment: .leading)
                            .padding(0)
                        
                        TextField("Email", text: $inputEmail)
                            .autocapitalization(.none) // 自動大文字化を無効化
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 280)
                            .padding(.top,-10)
                            .padding(.bottom,10)
                        
                        Text("パスワード")
                            .font(.system(size: 20,
                                          weight: .semibold))
                            .frame(maxWidth: 280, alignment: .leading)
                            .padding(0)
                        SecureField("Password", text: $inputPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 280)
                            .padding(.top,-10)

                    }
                    .frame(height: 200)
                    
                    // login button
                    Button(action: {
                        isLoginButtonDisabled = true
                        if inputEmail.isEmpty {
                            errorMessage = "メールアドレスを入力してください"
                            isLoginButtonDisabled = false
                            return
                        }
                        if inputPassword.isEmpty {
                            errorMessage = "パスワードを入力してください"
                            isLoginButtonDisabled = false
                            return
                        }
                        childLoginViewModel.register_child(email: inputEmail, password: inputPassword)
                    },
                           label: {
                        Text("ログインする")
                            .fontWeight(.medium)
                            .frame(minWidth: 160)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    })
                    .disabled(isLoginButtonDisabled)
                    
                    Spacer()
                    
                }
            }
        }
        .onChange(of: childLoginViewModel.loginSuccess) { _, success in
            if success {
                navigationModel.path.append("Child")
                isLoginButtonDisabled = false
            }
        }
        .onChange(of: childLoginViewModel.errorMessage ?? "") { _, msg in
            if !msg.isEmpty {
                errorMessage = msg
                isLoginButtonDisabled = false
            }
        }
    }
}


#Preview {
    ChildLoginView()
}
