//
//  MyProfile.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/27.
//

import SwiftUI

struct MyProfile: View {
    var body: some View {
        // 全体の縦構造
        VStack{
            // プロフィール
            VStack{
                // アイコン
                Image("chincoteague")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white,lineWidth: 4))
                    .shadow(radius: 10)
                // 名前
                Text("わたし")
                    .font(.title)
//                    .fontWeight(.black)
                    .padding(.top, 10.0)
                // 子供追加ボタン
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.gray)
                        .frame(width: 200, height: 40)
                    
                    Text("子供を追加する") // メッセージ
                        .font(.body)
                        .foregroundColor(.white)
//                        .fontWeight(.medium)
                }
                
            }
            .padding(.top, 100.0)
            
            Spacer()
            
            
        }
        .padding(EdgeInsets(top: -15, leading: 20, bottom: -20, trailing:20))

    }
    
}

#Preview {
    MyProfile()
}
