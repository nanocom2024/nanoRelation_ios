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
                
                Text("アカウント作成")
                    .font(.system(size: 40,
                                  weight: .heavy))
                
//                Text("SignupView")
//                    .font(.system(size: 40,
//                                  weight: .heavy))
                
                if errorMessage != "" {
//                    Spacer()
                    Text(errorMessage)
                        .foregroundStyle(Color.red)
                        .frame(width: 300, height: 10) // 幅と高さを固定

                }

                VStack {
                    Text("名前")
                        .font(.system(size: 20,
                                      weight: .semibold))
                        .frame(maxWidth: 280, alignment: .leading)
                        .padding(0)
                    
                    TextField("Name", text: $inputName)
                        .autocapitalization(.none) // 自動大文字化を無効化
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                        .padding(.top,-10)
                        .padding(.bottom,10)
                    
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
                .frame(height:230)

                // create button
                Button(action: {
                    isCreateButtonDisabled = true
                    if inputName.isEmpty {
                        errorMessage = "名前を入力してください"
                        isCreateButtonDisabled = false
                        return
                    }
                    if inputEmail.isEmpty {
                        errorMessage = "メールアドレスを入力してください"
                        isCreateButtonDisabled = false
                        return
                    }
                    if inputPassword.isEmpty {
                        errorMessage = "パスワードを入力してください"
                        isCreateButtonDisabled = false
                        return
                    }
                    signupViewModel.signup(name: inputName, email: inputEmail, password: inputPassword)
                },
                label: {
                    Text("登録")
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
