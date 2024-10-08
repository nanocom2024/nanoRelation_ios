//
//  ThirdView.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/27.
//

import SwiftUI

struct ChildView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    var body: some View {
        
        VStack {
            MyChildrenList()
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
                        Image(systemName: "person.2.slash.fill")
                            .font(Font.system(size: 25))
                            .padding(.bottom, -10)
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
                        Image(systemName: "person.fill")
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
                        Image(systemName: "figure.and.child.holdinghands")
                            .font(Font.system(size: 25))
                            .padding(.bottom, -5)
                        Text("子供")
                            .fontWeight(.light)
                            .font(.subheadline)

                    }
//                    .foregroundColor(.gray)
                    .foregroundColor(.blue)
                    
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
                    .foregroundColor(.gray)
//                    .foregroundColor(.blue)
                    
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
    ChildView()
        .environmentObject(NavigationModel())
}
