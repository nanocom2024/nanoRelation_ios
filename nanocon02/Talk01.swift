//
//  Talk01.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/27.
//

import SwiftUI

struct Talk01: View {
    var body: some View {
        VStack{//全体の縦構造
            HStack{//プロフィール
//                Image(systemName: "arrow.uturn.left")
//                    .font(Font.system(size: 40, weight: .medium))
//                    .padding(10)
                Image("charleyrivers")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .padding(.leading,20)
                Text("名前")
                    .font(.title)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack{//メッセージ全体ーーーーーーーーーーーーー
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.yellow)
                        .frame(width: 370, height: 50)
                    
                    Text("愛知県中区○○○○　周辺ですれ違った") // メッセージ
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                HStack {//日時
                    Spacer()
                    Text("2024年1月20日　18時23分")
                        .padding(.top,-10)
                        .padding(.trailing,25)
                }//日時
            }//メッセージ全体ーーーーーーーーーーーーー
            
            VStack{//メッセージ全体ーーーーーーーーーーーーー
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.yellow)
                        .frame(width: 370, height: 50)
                    
                    Text("愛知県中区○○○○　周辺ですれ違った") // メッセージ
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                HStack {//日時
                    Spacer()
                    Text("2024年1月20日　18時23分")
                        .padding(.top,-10)
                        .padding(.trailing,25)
                }//日時
                
                HStack{//未読メッセージアイコン
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(Font.system(size: 30, weight: .medium))
                        .foregroundColor(.red)
                        .padding(.top,-100)
                        .padding(.leading,5)
                    Spacer()
                }//未読メッセージアイコン
            }//メッセージ全体ーーーーーーーーーーーーー
            
            VStack{//メッセージ全体ーーーーーーーーーーーーー
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.yellow)
                        .frame(width: 370, height: 50)
                    
                    Text("愛知県中区○○○○　周辺ですれ違った") // メッセージ
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                HStack {//日時
                    Spacer()
                    Text("2024年1月20日　18時23分")
                        .padding(.top,-10)
                        .padding(.trailing,25)
                }//日時
                
                HStack{//未読メッセージアイコン
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(Font.system(size: 30, weight: .medium))
                        .foregroundColor(.red)
                        .padding(.top,-100)
                        .padding(.leading,5)
                    Spacer()
                }//未読メッセージアイコン
            }//メッセージ全体ーーーーーーーーーーーーー
            
            VStack{//　迷子　メッセージ全体ーーーーーーーーーーーーー
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.red)
                        .frame(width: 370, height: 50)
                    
                    Text("なまえ　の子供が迷子になりました!") // メッセージ
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                HStack {//日時
                    Spacer()
                    Text("2024年1月20日　18時23分")
                        .padding(.top,-10)
                        .padding(.trailing,25)
                }//日時
            }//メッセージ全体ーーーーーーーーーーーーー
            VStack{//　迷子とすれ違い　メッセージ全体ーーーーーーーーーーーーー
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.green)
                        .frame(width: 370, height: 50)
                    
                    Text("愛知県中区○○○○　周辺で\nタロウ　とすれ違った") // メッセージ
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                HStack {//日時
                    Spacer()
                    Text("2024年1月20日　18時23分")
                        .padding(.top,-10)
                        .padding(.trailing,25)
                }//日時
            }//メッセージ全体ーーーーーーーーーーーーー
            Spacer()
        }
        .padding(EdgeInsets(top:0,leading: -5,bottom: -20,trailing:-5))
    }
}


#Preview {
    Talk01()
}
