//
//  Talk02.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/27.
//

import SwiftUI

struct Talk02: View {
//    @State var text = "情報提供する"
    @State private var isButtonTapped = false


    var body: some View {
        VStack{//全体の縦構造
            HStack{//プロフィール
                
                Image("chilkoottrail")
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
            Spacer()

            Button(action: {//情報提供許可ボタンーーーーーーーーーーーーー
                isButtonTapped.toggle()
            }){
                Text(isButtonTapped ? "情報提供をやめる" : "情報を提供する")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .frame(width: 370, height: 60)
            }
            .accentColor(Color.white)
            .background(isButtonTapped ? Color.red : Color.blue)
            .cornerRadius(.infinity)
        }
        .padding(EdgeInsets(top:0,leading: -5,bottom: -10,trailing:-5))

    }
    
}

#Preview {
    Talk02()
}
