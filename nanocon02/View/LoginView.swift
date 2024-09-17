//
//  LoginView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/08.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var inputEmail: String = ""
    @State private var inputPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoginButtonDisabled = false
    @EnvironmentObject private var navigationModel: NavigationModel
    
    
    var body: some View {
            
            Group {
                if loginViewModel.isLoading {
                    VStack(alignment: .center) {
                        ProgressView("Logging in...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    }
                } else {
                    VStack(alignment: .center) {
                        Spacer()
                        //                    Text("NanoRelation")
                        //                        .font(.system(size: 48,
                        //                                      weight: .heavy))
                        Text("ログイン")
                            .font(.system(size: 40,
                                          weight: .heavy))
                        
                        if errorMessage != "" {
//                            Spacer()
                            Text(errorMessage)
                                .foregroundStyle(Color.red)
                                .frame(width: 300, height: 10)

                        }
                        
                        VStack{
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
                        
                        Button(action: {
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
                            loginViewModel.signin(email: inputEmail, password: inputPassword)
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
                        
                        Spacer().frame(height: 20)
                        
                        Button(action: {
                            var transaction = Transaction()
                            transaction.disablesAnimations = true
                            withTransaction(transaction) {
                                navigationModel.path.append("signup")
                            }
                        },
                               label: {
                            Text("新規登録")
                                .fontWeight(.medium)
                                .frame(minWidth: 160)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.accentColor)
                                .cornerRadius(8)
                        })
                        .navigationDestination(for: String.self) { value in
                            switch value {
                            case "singup":
                                SignupView()
                            default:
                                Text("Unknown destination")
                            }
                        }
                        
                        Spacer()
                }
            }
        }
        .onChange(of: loginViewModel.loginSuccess) { _, success in
            if success {
                navigationModel.path.append("test")
                isLoginButtonDisabled = false
            }
        }
        .onChange(of: loginViewModel.errorMessage ?? "") { _, msg in
            if !msg.isEmpty {
                errorMessage = msg
                isLoginButtonDisabled = false
            }
        }
        // 戻るボタンを非表示にする
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    LoginView()
        .environmentObject(NavigationModel())
    
}
