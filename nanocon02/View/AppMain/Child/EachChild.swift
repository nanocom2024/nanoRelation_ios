//
//  Talk03.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/27.
//

import SwiftUI

struct EachChild: View {
    // @Stateでメッセージのリストを管理
    @State private var messages: [Message] = []
    let oneChild: Child
    
    @State private var errMsg = ""
    @State private var isLost = false
    @StateObject private var eachChildViewModel = EachChildViewModel()
    
    
    var body: some View {
        NavigationView { //これがないとtoolbarが使えない
            // 全体の縦構造
            VStack{
                // プロフィール
                HStack{
                    Image("test-img")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(.leading,20)
                    Text(oneChild.name) // 配列内のメッセージを表示
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                }
                
                if errMsg != "" {
                    Text(errMsg)
                        .foregroundStyle(Color.red)
                }
                
                ScrollView { //スクロールする領域を指定
                    // ーーーーーーーーーーーーーーーーーmessages配列の要素をどのように並べるか、デザインーーーーーーーーーーーーーーーーーーー
                    ForEach(messages) { message in //ForEach　配列の要素を構成するとき使い回しするもの
                        VStack { // メッセージ全体ーーーーーーーーーーーーー
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(message.color)
                                    .frame(width: 330, height: 37)
                                
                                Text(message.text) // 配列内のメッセージを表示
                                    .lineSpacing(-10) // 改行の行間を詰める
                                    .font(.body)
                                //                                    .fontWeight(.semibold)
                                
                                HStack{ //未読メッセージアイコン
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(Font.system(size: 20, weight: .medium))
                                        .foregroundColor(.red)
                                        .padding(.top,-20)
                                        .padding(.leading,20)
                                    Spacer()
                                } //未読メッセージアイコン
                            }
                            .padding(.top,10)
                            
                            HStack { // 日時
                                Spacer()
                                Text(dateFormatter.string(from: message.date))
                                    .padding(.top, -10)
                                    .padding(.trailing, 40)
                                
                            } // 日時
                        } // メッセージ全体ーーーーーーーーーーーーー
                    } // messages配列の中身を表示
                    // ーーーーーーーーーーーーーーーーーmessages配列の要素をどのように並べるか、デザインーーーーーーーーーーーーーーーーーーー
                    
                } // ScrollView
                
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        // ボタンーーーーーーーーーーーーー
                        Button(action: {
                            // メッセージを追加（黄色）
                            messages.append(Message(text: "愛知県中区○○○○　周辺ではぐれた", color: .yellow, date: Date()))
                        }) {
                            Text("はぐれた")
                        }
                        .frame(width: 100, height: 35) // ボタンのサイズを固定
                        .accentColor(Color.black)
                        .background(Color.yellow)
                        .cornerRadius(26)
                        .disabled(errMsg != "")
                        
                        Spacer()
                        // ボタンーーーーーーーーーーーーー
                        
                        // ボタンーーーーーーーーーーーーー
                        Button(action: {
                            // メッセージを追加（黄色）
                            messages.append(Message(text: "なまえ さん　情報提供者がいます", color: .green, date: Date()))
                        }) {
                            Text("情報提供者")
                        }
                        .frame(width: 130, height: 35) // ボタンのサイズを固定
                        .accentColor(Color.black)
                        .background(Color.green)
                        .cornerRadius(26)
                        .disabled(errMsg != "")
                        
                        Spacer()
                        // ボタンーーーーーーーーーーーーー
                        
                        // ボタンーーーーーーーーーーーーー
                        Button(action: {//情報提供許可ボタンーーーーーーーーーーーーー
                            if isLost {
                                Task {
                                    let msg = Message(tag: "end", text: "迷子アラートを解除しました", color: .blue, date: Date())
                                    
                                    guard let res = await eachChildViewModel.delete_lost_info(child_uid: oneChild.id) else {
                                        errMsg = eachChildViewModel.errorString
                                        return
                                    }
                                    if !res {
                                        return
                                    }
                                    
                                    guard let res = await eachChildViewModel.addMsg(child_uid: oneChild.id, newMsg: msg) else {
                                        errMsg = eachChildViewModel.errorString
                                        return
                                    }
                                    if !res {
                                        return
                                    }
                                    
                                    DispatchQueue.main.async {
                                        // メッセージを追加
                                        isLost = false
                                        messages.append(msg)
                                    }
                                }
                            } else {
                                Task {
                                    let msg = Message(tag: "start", text: "迷子アラートを発信しました", color: .red, date: Date())
                                    
                                    guard let res = await eachChildViewModel.register_lost(child_uid: oneChild.id) else {
                                        errMsg = eachChildViewModel.errorString
                                        return
                                    }
                                    if !res {
                                        return
                                    }
                                    
                                    guard let res = await eachChildViewModel.addMsg(child_uid: oneChild.id, newMsg: msg) else {
                                        errMsg = eachChildViewModel.errorString
                                        return
                                    }
                                    if !res {
                                        return
                                    }
                                    
                                    DispatchQueue.main.async {
                                        // メッセージを追加
                                        isLost = true
                                        messages.append(msg)
                                    }
                                }
                            }
                        }){
                            
                            Text(isLost ? "アラート解除" : "アラート発信")
                            //.font(.largeTitle)//*****
                            //.fontWeight(.semibold)
                            //.frame(width: 370, height: 60)
                        }
                        .frame(width: 130, height: 35) // ボタンのサイズを固定
                        .accentColor(Color.white)
                        .background(isLost ? Color.blue : Color.red)
                        .cornerRadius(26)
                        .disabled(errMsg != "")
                        //                    .cornerRadius(.infinity)//*****
                        
                        Spacer()
                        // ボタンーーーーーーーーーーーーー
                        
                    } // ToolbarItemGroup
                } // .toolbar
            } // MARK: END - VStack
            .onAppear {
                Task {
                    if let res = await eachChildViewModel.isLost(uid: oneChild.id) {
                        isLost = res
                    } else {
                        errMsg = eachChildViewModel.errorString
                    }
                }
                Task {
                    messages = await eachChildViewModel.getMessages(child_uid: oneChild.id)
                }
            }
            
            
        }
        .padding(EdgeInsets(top:0,leading: -5,bottom: -20,trailing:-5))
    }
    // 日時を日本形式で表示するためのDateFormatter
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
        return formatter
    }
}

#Preview {
    EachChild(oneChild: Child(id: "test", name: "なまえ", name_id: "#xxxx"))
}
