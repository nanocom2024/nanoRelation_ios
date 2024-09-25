//
//  FriendList.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/23.
//

import SwiftUI

struct FriendList: View {
    // メッセージの構造体
    struct Friend: Identifiable {
        let id = UUID()
        let text: String
        let image: Image
    }
    
    // @Stateでメッセージのリストを管理
    @State private var friends: [Friend] = []
    @EnvironmentObject private var navigationModel: NavigationModel
    
    
    var body: some View {
        // 全体の縦構造
        VStack{
            // MARK: ナビゲーションバー
            HStack{
                Spacer()
                
                // plus mark
                Button(action: {
                    friends.append(Friend(text: "なまえ", image: Image("test-img")))
                }) {
                    Image(systemName: "plus.circle")
                        .font(Font.system(size: 30, weight: .light))
//                        .foregroundColor(.gray)
                        .foregroundColor(.black)
                }
                
                Spacer().frame(width: 10)
                
                // setting mark
                Button(action: {
                    // test viewへ
                    navigationModel.path.append("settings")
                }) {
                    Image(systemName: "gearshape")
                        .font(Font.system(size: 30, weight: .light))
                        .foregroundColor(.black)
                }
                
            }
            // MARK: - END ナビゲーションバー
            
            ScrollView { //スクロールする領域を指定
// ーーーーーーーーーーーーーーーーーmessages配列の要素をどのように並べるか、デザインーーーーーーーーーーーーーーーーーーー
                ForEach(friends) { friend in //ForEach　配列の要素を構成するとき使い回しするもの
                    
                    NavigationLink(destination: Talk01()) {
                        // 各個人
                        HStack{
                            friend.image
                                .resizable()
                                .frame(width: 55, height: 55)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading){
                                Text(friend.text) // 配列内のメッセージを表示
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Text("2024年10月20日 18時23分")
                                    .frame(width: 180)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
//                                    .background(.yellow)
                                    
                            }
                            
                            Spacer()
                            
                            Image(systemName: "figure.walk.circle")
                                .padding(-3.0)
                                .font(Font.system(size: 40, weight: .light))
                                .foregroundColor(.gray)

                            
                            Image(systemName: "speaker.wave.2.circle")
                                .font(Font.system(size: 40, weight: .light))
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom,15)
                    }
                } // messages配列の中身を表示
// ーーーーーーーーーーーーーーーーーmessages配列の要素をどのように並べるか、デザインーーーーーーーーーーーーーーーーーーー
            } // ScrollView
            
        }
        .padding(EdgeInsets(top: 20, leading: 25, bottom: 0, trailing:25))
        
    }
    // MARK: END - var body: some View
}


#Preview {
    FriendList()
}
