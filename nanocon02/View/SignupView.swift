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
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                        .padding(.top,-10)
                        .padding(.bottom,10)
                    
                    Text("パスワード")
                        .font(.system(size: 20,
                                      weight: .semibold))
                        .frame(maxWidth: 280, alignment: .leading)
                        .padding(0)
                    
                    TextField("Password", text: $inputPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                        .padding(.top,-10)
                    

                }
                .frame(height:230)

                Button(action: {
                    if inputName.isEmpty {
                        errorMessage = "名前を入力してください"
                        return
                    }
                    if inputEmail.isEmpty {
                        errorMessage = "メールアドレスを入力してください"
                        return
                    }
                    if inputPassword.isEmpty {
                        errorMessage = "パスワードを入力してください"
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
                
                Spacer()
            }
            
        }
        .onChange(of: signupViewModel.signupSuccess) { _, success in
            navigationModel.path.append("test")
        }
        .onChange(of: signupViewModel.errorMessage ?? "") { _, msg in
            if !msg.isEmpty {
                errorMessage = msg
            }
        }
    }
}

#Preview {
    SignupView()
}
