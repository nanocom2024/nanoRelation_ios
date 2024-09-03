//
//  Talk03.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/27.
//

import SwiftUI

struct Talk03: View {
    @State private var isButtonTapped = false
    var body: some View {
        VStack{//全体の縦構造
            HStack{//プロフィール
//                Image(systemName: "arrow.uturn.left")
//                    .font(Font.system(size: 40, weight: .medium))
//                    .padding(10)
                Image("hiddenlake")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .padding(.leading,20)
                Text("なまえ")
                    .font(.title)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack{//メッセージ全体ーーーーーーーーーーーーー
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.yellow)
                        .frame(width: 370, height: 50)
                    
                    Text("愛知県中区○○○○　周辺ではぐれた") // メッセージ
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
                    
                    Text("愛知県中区○○○○　周辺ではぐれた") // メッセージ
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
                    
                    Text("子供が迷子になって30分経過しました!") // メッセージ
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
            
            VStack{//　情報提供者　メッセージ全体ーーーーーーーーーーーーー
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.green)
                        .frame(width: 370, height: 80)
                    
                    HStack{//プロフィール
                        Image("chincoteague")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                        Text("名前")
                            .font(.title)
                            .fontWeight(.black)
                        
                        Text("情報提供者がいます") // メッセージ
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
//                    .padding(.leading,15)
                }
                HStack {//日時
                    Spacer()
                    Text("2024年1月20日　18時23分")
                        .padding(.top,-10)
                        .padding(.trailing,25)
                }//日時
            }//　情報提供者　メッセージ全体ーーーーーーーーーーーーー
            
            Spacer()
            
            Button(action: {//情報提供許可ボタンーーーーーーーーーーーーー
                isButtonTapped.toggle()
            }){
                Text(isButtonTapped ? "迷子アラートを解除する" : "迷子アラートを発信する")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .frame(width: 370, height: 60)
            }
            .accentColor(Color.white)
            .background(isButtonTapped ? Color.red : Color.blue)
            .cornerRadius(.infinity)
            //情報提供許可ボタンーーーーーーーーーーーーー

        }
        .padding(.bottom, -10)
        .padding(.leading, -5)
        .padding(.trailing, -5)
    }
    
}

#Preview {
    Talk03()
}
