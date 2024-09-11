//
//  TestView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/08.
//

import SwiftUI

struct TestView: View {
    let cookieManager = CookieManager()
    @StateObject private var testViewModel = TestViewModel()
    @EnvironmentObject var navigationModel: NavigationModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Spacer()
                Button(action: {
                    testViewModel.signout()
                    navigationModel.path.removeLast(navigationModel.path.count)
                }, label: {
                    Text("signout")
                })
                Spacer()
            }
            Spacer()
            Text(Auth.getToken() ?? "token not found")
            Spacer()
            
            VStack {
                Spacer()
                
                Button(action: {
                    navigationModel.path.append("search device")
                }, label: {
                    Text("search Device")
                })
                
                Spacer()
                
                NavigationLink(
                    destination: DeleteView(),
                    label: {
                        Text("Delete Account")
                            .frame(width: 140, height: 40)
                            .font(.body)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                )
                .buttonStyle(PlainButtonStyle())
            }
        }
        // 戻るボタンを非表示にする
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TestView()
}
