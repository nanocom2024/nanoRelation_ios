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
    @State private var isButtonDisabled = false
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
                    
                    Text("NanoRelation-ios")
                        .font(.system(size: 48,
                                      weight: .heavy))
                    
                    Text("LoginView")
                        .font(.system(size: 40,
                                      weight: .heavy))
                    
                    if errorMessage != "" {
                        Spacer()
                        Text(errorMessage)
                            .foregroundStyle(Color.red)
                    }
                    
                    VStack(spacing: 24) {
                        TextField("Mail address", text: $inputEmail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 280)
                        
                        SecureField("Password", text: $inputPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 280)
                        
                    }
                    .frame(height: 200)
                    
                    // login button
                    Button(action: {
                        isButtonDisabled = true
                        if inputEmail.isEmpty {
                            errorMessage = "Missing email"
                            isButtonDisabled = false
                            return
                        }
                        if inputPassword.isEmpty {
                            errorMessage = "Missing password"
                            isButtonDisabled = false
                            return
                        }
                        loginViewModel.signin(email: inputEmail, password: inputPassword)
                    },
                           label: {
                        Text("Login")
                            .fontWeight(.medium)
                            .frame(minWidth: 160)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    })
                    .disabled(isButtonDisabled)
                    
                    Spacer().frame(height: 20)
                    
                    NavigationLink(destination: SignupView()) {
                        Text("create account")
                            .font(.body)
                            .foregroundColor(.blue)
                            .underline()
                    }
                    
                    Spacer()
                }
            }
        }
        .onChange(of: loginViewModel.loginSuccess) { _, success in
            if success {
                navigationModel.path.append("test")
                isButtonDisabled = false
            }
        }
        .onChange(of: loginViewModel.errorMessage ?? "") { _, msg in
            if !msg.isEmpty {
                errorMessage = msg
                isButtonDisabled = false
            }
        }
        // 戻るボタンを非表示にする
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    LoginView()
}
