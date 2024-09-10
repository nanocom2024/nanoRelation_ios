//
//  Talk01.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/27.
//

import SwiftUI

struct Talk02: View {
    // メッセージの構造体
    struct Message: Identifiable {
        let id = UUID()
        let text: String
        let color: Color
        let date: Date  // メッセージの日時
    }
    
    // @Stateでメッセージのリストを管理
    @State private var messages: [Message] = []
    
    @State private var isButtonTapped = false

    
    var body: some View {
        NavigationView {//これがないとtoolbarが使えない
            VStack{//全体の縦構造
                HStack{//プロフィール
                    //                Image(systemName: "arrow.uturn.left")
                    //                    .font(Font.system(size: 40, weight: .medium))
                    //                    .padding(10)
                    Image("chincoteague")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .padding(.leading,20)
                    Text("名前")
                        .font(.title)
                        .fontWeight(.semibold)
                    Spacer()
                }
                
                ScrollView {//スクロールする領域を指定
// ーーーーーーーーーーーーーーーーーmessages配列の要素をどのように並べるか、デザインーーーーーーーーーーーーーーーーーーー
                    ForEach(messages) { message in//ForEach　配列の要素を構成するとき使い回しするもの
                        VStack { // メッセージ全体ーーーーーーーーーーーーー
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(message.color)
                                    .frame(width: 370, height: 50)
                                
                                Text(message.text) // 配列内のメッセージを表示
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            
                            HStack { // 日時
                                Spacer()
                                Text(dateFormatter.string(from: message.date))
                                    .padding(.top, -10)
                                    .padding(.trailing, 25)
                            } // 日時
                            
                            HStack{//未読メッセージアイコン
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(Font.system(size: 30, weight: .medium))
                                    .foregroundColor(.red)
                                    .padding(.top,-100)
                                    .padding(.leading,5)
                                Spacer()
                            }//未読メッセージアイコン
                        } // メッセージ全体ーーーーーーーーーーーーー
                    }// messages配列の中身を表示
// ーーーーーーーーーーーーーーーーーmessages配列の要素をどのように並べるか、デザインーーーーーーーーーーーーーーーーーーー
                } // ScrollView
                
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        // ボタンーーーーーーーーーーーーー
                        Button(action: {
                            // メッセージを追加（黄色）
                            messages.append(Message(text: "愛知県中区○○○○　周辺ですれ違った", color: .yellow, date: Date()))
                        }) {
                            Text("すれ違い")
                        }
                        .padding()
                        .accentColor(Color.black)
                        .background(Color.yellow)
                        .cornerRadius(26)
                        
                        Spacer()
                        // ボタンーーーーーーーーーーーーー
                        
                        // ボタンーーーーーーーーーーーーー
                        Button(action: {//情報提供許可ボタンーーーーーーーーーーーーー
                            if isButtonTapped {
                                // isButtonTappedがtrueのときの処理
                                // メッセージを追加（赤色）
                                messages.append(Message(text: "情報提供をやめました！", color: .red, date: Date()))
                            } else {
                                // isButtonTappedがfalseのときの処理
                                // メッセージを追加（青色）
                                messages.append(Message(text: "情報を提供しました！", color: .blue, date: Date()))
                            }
                            // ボタンの状態をトグル
                            isButtonTapped.toggle()
                        }){
                            
                            Text(isButtonTapped ? "情報提供をやめる" : "情報を提供する")
                            //.font(.largeTitle)//*****
                            //.fontWeight(.semibold)
                            //.frame(width: 370, height: 60)
                        }
                        .padding()
                        .accentColor(Color.white)
                        .background(isButtonTapped ? Color.red : Color.blue)
                        .cornerRadius(26)
    //                    .cornerRadius(.infinity)//*****
                        
                        Spacer()
                        // ボタンーーーーーーーーーーーーー
                    } // ToolbarItemGroup
                } // .toolbar
            } // NavigationView
            
            
        }//var body: some View
        .padding(EdgeInsets(top:0,leading: -5,bottom: -20,trailing:-5))
    }//struct Talk01: View
    
    // 日時を日本形式で表示するためのDateFormatter
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
        return formatter
    }
}


#Preview {
    Talk02()
}
