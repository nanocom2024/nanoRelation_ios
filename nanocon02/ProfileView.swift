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
                        Image(systemName: "person.fill")
                            .font(.system(size: 25))
                            .padding(.bottom, -5)
                        Text("友達")
                            .fontWeight(.light)
                            .font(.subheadline)
                    }
                    .foregroundColor(.gray)
//                    .foregroundColor(.blue)
                })
                Spacer()
                
                //ーーーーーーーーーーーーーーーーーーーーーーーーーーーーボタンーーーーーーーーーーーーーーーーーーーー
                // LostChild
                
                Button(action: {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        navigationModel.path.append("LostChild")
                    }
                },
                       label: {
                    VStack{
                        Image(systemName: "person.2.slash.fill")
                            .font(Font.system(size: 25))
                            .padding(.bottom, -10)
                        Text("迷子リスト")
                            .fontWeight(.light)
                            .font(.subheadline)


                    }
                    .foregroundColor(.gray)
//                    .foregroundColor(.blue)
                    
                })
                Spacer()

                
                //ーーーーーーーーーーーーーーーーーーーーーーーーーーーーボタンーーーーーーーーーーーーーーーーーーーー
                
                Button(action: {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        navigationModel.path.append("Third")
                    }
                },
                       label: {
                    VStack{
                        Image(systemName: "figure.and.child.holdinghands")
                            .font(Font.system(size: 25))
                            .padding(.bottom, -5)
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
                
                .navigationDestination(for: String.self) { value in
                    switch value {
                    case "Friend":
                        FriendView()
                    case "LostChild":
                        LostChildView()
                    case "Third":
                        ThirdView()
                    case "Profile":
                        ProfileView()
                    default:
                        Text("Unknown destination")
                    }
                }
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
