//
//  LostChildren.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/25.
//

import SwiftUI

struct LostChildren: View {
    // メッセージの構造体
    struct LostChild: Identifiable {
        let id = UUID()
        let text: String
        let image: Image
    }

    // @Stateでメッセージのリストを管理
    @State private var lostchildren: [LostChild] = []
    
    
    
    var body: some View {
        VStack{//全体の縦構造
            HStack{//検索バーの部分
                Spacer()
                Button(action: {
                    lostchildren.append(LostChild(text: "なまえ", image: Image("chincoteague")))
                }) {
                    Image(systemName: "plus.circle")
                        .font(Font.system(size: 30, weight: .light))
//                        .foregroundColor(.gray)
                        .foregroundColor(.black)
                }
            }
            
            ScrollView {//スクロールする領域を指定
// ーーーーーーーーーーーーーーーーーmessages配列の要素をどのように並べるか、デザインーーーーーーーーーーーーーーーーーーー
                ForEach(lostchildren) { lostchild in//ForEach　配列の要素を構成するとき使い回しするもの
                    
                    NavigationLink(destination: Talk02()) {
                        HStack{//各個人
                            lostchild.image
                                .resizable()
                                .frame(width: 55, height: 55)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading){
                                Text(lostchild.text) // 配列内のメッセージを表示
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
                }// messages配列の中身を表示
// ーーーーーーーーーーーーーーーーーmessages配列の要素をどのように並べるか、デザインーーーーーーーーーーーーーーーーーーー
            } // ScrollView
            
        }//var body: some View
        .padding(EdgeInsets(top:20,leading: 25,bottom: 0,trailing:25))
    }//struct Talk01: View
}


#Preview {
    LostChildren()
}
