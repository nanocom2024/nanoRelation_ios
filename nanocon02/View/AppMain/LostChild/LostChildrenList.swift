//
//  LostChildren.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/25.
//

import SwiftUI

struct LostChildrenList: View {
    // @Stateでメッセージのリストを管理
    @State private var now = "nopass"
    
    
    @EnvironmentObject private var navigationModel: NavigationModel
    
    
    
    var body: some View {
        NavigationView {//これがないとtoolbarが使えない
            VStack{
                HStack{//プロフィール
//                    Image("test-img")
//                        .resizable()
//                        .frame(width: 50, height: 50)
//                        .clipShape(Circle())
//                        .padding(.leading,20)
//                    Text("名前") // 配列内のメッセージを表示
//                        .font(.headline)
//                        .foregroundColor(.black)
                    Spacer()
                    // setting mark
                    Button(action: {
                        // test viewへ
                        navigationModel.path.append("settings")
                    }) {
                        Image(systemName: "gearshape")
                            .font(Font.system(size: 30, weight: .light))
                            .foregroundColor(.black)
                    }
                    .padding(.trailing,25)
                }
                Spacer()
                // ーーーーーーーーーーーーーーーーnoInteractionの状態に応じて表示を切り替える
                switch now {
                case "nopass":
                    ZStack {
                        Color.gray.opacity(0.2) // 背景色を指定し、透明度を調整
                            .edgesIgnoringSafeArea(.all) // 画面全体に適用
                            .cornerRadius(50)
                        VStack {
                            Image(systemName: "person.2.slash.fill")
                                .font(Font.system(size: 100))
                                .foregroundColor(.gray)
                            
                            Text("すれ違った人はいません")
                                .font(.largeTitle)
                                .fontWeight(.regular)
                                .foregroundColor(.gray)
                        }
                        .frame(height: 300)
                        .padding(EdgeInsets(top:0,leading: 25,bottom: 0,trailing:25))
                    }
                case "pass":
                    ZStack {
                        Color.green.opacity(0.2) // 背景色を指定し、透明度を調整
                            .edgesIgnoringSafeArea(.all) // 画面全体に適用
                            .cornerRadius(50)
                        VStack {
                            // アイコン
                            Image("test-img")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white,lineWidth: 4))
                                .shadow(radius: 10)
                            
                            Text("名前 と\nすれ違いました")
                                .font(.largeTitle)
                                .fontWeight(.regular)
                                .multilineTextAlignment(.center) // 中央揃えにする
                        }
                        .frame(height: 300)
                        .padding(EdgeInsets(top:0,leading: 5,bottom: 0,trailing:5))
                    }
                case "lost":
                    ZStack {
                        Color.red.opacity(0.2) // 背景色を指定し、透明度を調整
                                .edgesIgnoringSafeArea(.all) // 画面全体に適用
                                .cornerRadius(50)
                        VStack {
                            // アイコン
                            Image("test-img")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white,lineWidth: 4))
                                .shadow(radius: 10)
                            
                            Text("迷子の子供が\n近くにいます")
                                .font(.largeTitle)
                                .fontWeight(.regular)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center) // 中央揃えにする
                            
                        }
                        .frame(height: 300)
                        .padding(EdgeInsets(top:0,leading: 5,bottom: 0,trailing:5))
                    }
                default:
                    VStack {
                        Text("error")
                    }
                }
                Spacer()
            }
            
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    // ボタンーーーーーーーーーーーーー
                    Button(action: {
                        now = "nopass"
                    }) {
                        Text("すれ違いなし")
                    }
                    .frame(width: 120, height: 35) // ボタンのサイズを固定
                    .accentColor(Color.black)
                    .background(Color.yellow)
                    .cornerRadius(26)
                    Spacer()
                    // ボタンーーーーーーーーーーーーー
                    
                    // ボタンーーーーーーーーーーーーー
                    Button(action: {
                        now = "pass"
                    }) {
                        Text("すれ違った")
                    }
                    .frame(width: 100, height: 35) // ボタンのサイズを固定
                    .accentColor(Color.black)
                    .background(Color.green)
                    .cornerRadius(26)
                    Spacer()
                    // ボタンーーーーーーーーーーーーー
                    
                    // ボタンーーーーーーーーーーーーー
                    Button(action: {
                        now = "lost"
                    }) {
                        Text("迷子が近くにいる")
                    }
                    .frame(width: 150, height: 35) // ボタンのサイズを固定
                    .accentColor(Color.black)
                    .background(Color.red)
                    .cornerRadius(26)
                    Spacer()
                    // ボタンーーーーーーーーーーーーー
                    
                } // ToolbarItemGroup
            } // .toolbar
        } // NavigationView
        
    }//var body: some View
    
    
    // 日時を日本形式で表示するためのDateFormatter
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
        return formatter
    }
}


#Preview {
    LostChildrenList()
}
