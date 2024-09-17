//
//  SignupView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/08.
//

import SwiftUI

struct SignupView: View {
    @StateObject private var signupViewModel = SignupViewModel()
    @State private var inputName: String = ""
    @State private var inputEmail: String = ""
    @State private var inputPassword: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var errorMessage: String = ""
    @State private var isCreateButtonDisabled = false
    @EnvironmentObject private var navigationModel: NavigationModel

    var body: some View {
        VStack(alignment: .center) {
            if signupViewModel.isLoading {
                ProgressView("create...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                Spacer()
                
                Text("NanoRelation-ios")
                    .font(.system(size: 48,
                                  weight: .heavy))
                
                Text("SignupView")
                    .font(.system(size: 40,
                                  weight: .heavy))
                
                if errorMessage != "" {
                    Spacer()
                    Text(errorMessage)
                        .foregroundStyle(Color.red)
                }

                VStack(spacing: 24) {
                    TextField("Your name", text: $inputName)
                        .autocapitalization(.none) // 自動大文字化を無効化
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                    
                    TextField("Mail address", text: $inputEmail)
                        .autocapitalization(.none) // 自動大文字化を無効化
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)

                    SecureField("Password", text: $inputPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)

                }
                .frame(height: 200)

                // create button
                Button(action: {
                    isCreateButtonDisabled = true
                    if inputName.isEmpty {
                        errorMessage = "Missing name"
                        isCreateButtonDisabled = false
                        return
                    }
                    if inputEmail.isEmpty {
                        errorMessage = "Missing email"
                        isCreateButtonDisabled = false
                        return
                    }
                    if inputPassword.isEmpty {
                        errorMessage = "Missing password"
                        isCreateButtonDisabled = false
                        return
                    }
                    signupViewModel.signup(name: inputName, email: inputEmail, password: inputPassword)
                },
                label: {
                    Text("create")
                        .fontWeight(.medium)
                        .frame(minWidth: 160)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                })
                .disabled(isCreateButtonDisabled)
                
                Spacer()
            }
            
        }
        .onChange(of: signupViewModel.signupSuccess) { _, success in
            navigationModel.path.append("Friend")
            isCreateButtonDisabled = false
        }
        .onChange(of: signupViewModel.errorMessage ?? "") { _, msg in
            if !msg.isEmpty {
                errorMessage = msg
                isCreateButtonDisabled = false
            }
        }
    }
}

#Preview {
    SignupView()
}
