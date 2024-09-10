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
    
    
    
    var body: some View {
        VStack{//全体の縦構造
            HStack{//検索バーの部分
                Spacer()
                Button(action: {
                    friends.append(Friend(text: "なまえ", image: Image("charleyrivers")))
                    
                }) {
                    Image(systemName: "plus.circle")
                        .font(Font.system(size: 35, weight: .regular))
                        .foregroundColor(.black)
                }
                
            }
            
            ScrollView {//スクロールする領域を指定
// ーーーーーーーーーーーーーーーーーmessages配列の要素をどのように並べるか、デザインーーーーーーーーーーーーーーーーーーー
                ForEach(friends) { friend in//ForEach　配列の要素を構成するとき使い回しするもの
                    
                    NavigationLink(destination: Talk01()) {
                        HStack{//各個人
                            friend.image
                                .resizable()
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading){
                                Text(friend.text) // 配列内のメッセージを表示
                                Text("2024年1月20日 18時23分")
                                    .font(.subheadline)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "figure.walk.circle")
                                .padding(-3.0)
                                .font(Font.system(size: 50, weight: .regular))
                            
                            Image(systemName: "speaker.wave.2.circle")
                                .font(Font.system(size: 50, weight: .regular))
                        }
                        .foregroundColor(.black)
                    }
                }// messages配列の中身を表示
// ーーーーーーーーーーーーーーーーーmessages配列の要素をどのように並べるか、デザインーーーーーーーーーーーーーーーーーーー
            } // ScrollView
            
        }//var body: some View
        .padding(EdgeInsets(top:0,leading: 20,bottom: 0,trailing:20))
    }//struct Talk01: View
}


#Preview {
    FriendList()
}
