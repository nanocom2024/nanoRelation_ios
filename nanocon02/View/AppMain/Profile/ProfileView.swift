//
//  FourthView.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/27.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    var body: some View {
        
        VStack {
            MyProfile()
            HStack{
                
                //ーーーーーーーーーーーーーーーーーーーーーーーーーーーーボタンーーーーーーーーーーーーーーーーーーーー
                // status
                
                Button(action: {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        navigationModel.path.append("LostChild")
                    }
                },
                       label: {
                    VStack{
                        Image(systemName: "dot.radiowaves.left.and.right")
                            .font(Font.system(size: 25))
//                            .padding(.bottom, -10)
                        Text("現在の状況")
                            .fontWeight(.light)
                            .font(.subheadline)


                    }
                    .foregroundColor(.gray)
//                    .foregroundColor(.blue)
                    
                })
                Spacer()

                //ーーーーーーーーーーーーーーーーーーーーーーーーーーーーボタンーーーーーーーーーーーーーーーーーーーー
                // Friend
                
                Button(action: {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        navigationModel.path.append("Friend")
                    }
                },
                       label: {
                    VStack {
                        Image(systemName: "note.text")
                            .font(.system(size: 25))
                            .padding(.bottom, -5)
                        Text("履歴")
                            .fontWeight(.light)
                            .font(.subheadline)
                    }
                    .foregroundColor(.gray)
//                    .foregroundColor(.blue)
                })
                Spacer()
                
                //ーーーーーーーーーーーーーーーーーーーーーーーーーーーーボタンーーーーーーーーーーーーーーーーーーーー
                // Child
                
                Button(action: {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        navigationModel.path.append("Child")
                    }
                },
                       label: {
                    VStack{
                        Image(systemName: "figure.child.and.lock")
                            .font(Font.system(size: 25))
                            .padding(.bottom, -8)
                        Text("子供")
                            .fontWeight(.light)
                            .font(.subheadline)

                    }
                    .foregroundColor(.gray)
//                    .foregroundColor(.blue)
                    
                })
                Spacer()

                
                //ーーーーーーーーーーーーーーーーーーーーーーーーーーーーボタンーーーーーーーーーーーーーーーーーーーー
                // Profile
                Button(action: {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        navigationModel.path.append("Profile")
                    }
                },
                       label: {
                    VStack{
                        Image(systemName: "person.circle.fill")
                            .font(Font.system(size: 25))
                            .padding(.bottom, -5)
                        Text("自分")
                            .fontWeight(.light)
                            .font(.subheadline)

                    }
//                    .foregroundColor(.gray)
                    .foregroundColor(.blue)
                    
                })

                //ーーーーーーーーーーーーーーーーーーーーーーーーーーーーボタンーーーーーーーーーーーーーーーーーーーー
                
            }
            .padding(EdgeInsets(top: 0, leading: 40, bottom: 10, trailing: 40))
        }
        .navigationViewStyle(StackNavigationViewStyle()) // スタックスタイルを使用
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ProfileView()
        .environmentObject(NavigationModel())
}
