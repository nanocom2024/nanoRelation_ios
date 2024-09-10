//
//  MyChildren.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/27.
//

import SwiftUI

struct MyChildren: View {
    // メッセージの構造体
    struct Child: Identifiable {
        let id = UUID()
        let text: String
        let image: Image
    }
    
    // @Stateでメッセージのリストを管理
    @State private var children: [Child] = []
    
    
    
    var body: some View {
        VStack{//全体の縦構造
            HStack{//検索バーの部分
                Spacer()
                Button(action: {
                    children.append(Child(text: "なまえ", image: Image("hiddenlake")))
                    
                }) {
                    Image(systemName: "plus.circle")
                        .font(Font.system(size: 35, weight: .regular))
                        .foregroundColor(.black)
                }
                
            }
            
            ScrollView {//スクロールする領域を指定
// ーーーーーーーーーーーーーーーーーmessages配列の要素をどのように並べるか、デザインーーーーーーーーーーーーーーーーーーー
                ForEach(children) { child in//ForEach　配列の要素を構成するとき使い回しするもの
                    
                    NavigationLink(destination: Talk03()) {
                        HStack{//各個人
                            child.image
                                .resizable()
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading){
                                Text(child.text) // 配列内のメッセージを表示
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
    MyChildren()
}
