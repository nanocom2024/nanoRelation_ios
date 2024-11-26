//
//  LostInfoView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/26.
//

import SwiftUI

struct LostInfoView: View {
    // @Stateでメッセージのリストを管理
    @State private var lostInfo: [LostInfo] = []
    
    @State private var errMsg = ""
    @StateObject private var lostInfoViewModel = LostInfoViewModel()
    
    
    var body: some View {
//        NavigationView { //これがないとtoolbarが使えない
            // 全体の縦構造
            VStack{
                // プロフィール
                HStack{
                    Text("迷子情報")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                
                if errMsg != "" {
                    Text(errMsg)
                        .foregroundStyle(Color.red)
                }
                
                ScrollView { //スクロールする領域を指定
                    // ーーーーーーーーーーーーーーーーーmessages配列の要素をどのように並べるか、デザインーーーーーーーーーーーーーーーーーーー
                    ForEach(lostInfo) { info in //ForEach　配列の要素を構成するとき使い回しするもの
                        VStack { // メッセージ全体ーーーーーーーーーーーーー
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(.yellow)
                                    .frame(width: 330, height: 50)

                                VStack(spacing: 5) {
                                    Text("緯度：\(info.latitude) 経度：\(info.longitude)") // 配列内のメッセージを表示
                                        .lineSpacing(-10) // 改行の行間を詰める
                                        .font(.body)

                                    Link("地図を開く", destination: URL(string: "https://maps.google.com?q=\(info.latitude),\(info.longitude)")!)
                                }
                                
                                HStack { // 未読メッセージアイコン
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(Font.system(size: 20, weight: .medium))
                                        .foregroundColor(.red)
                                        .padding(.top, -20)
                                        .padding(.leading, 20)
                                    Spacer()
                                }
                            }
//                            .padding(.top, 10)
                            .frame(maxWidth: 350) // 最大幅を制限
                            
                            HStack { // 日時
                                Spacer()
                                Text(dateFormatter.string(from: info.timestamp))
                                    .padding(.top, -10)
                                    .padding(.trailing, 40)
                            } // 日時
                        }
                        .frame(maxWidth: .infinity, alignment: .center) // 親ビューの幅を制限
                        .padding()
 // メッセージ全体ーーーーーーーーーーーーー
                    } // messages配列の中身を表示
                    // ーーーーーーーーーーーーーーーーーmessages配列の要素をどのように並べるか、デザインーーーーーーーーーーーーーーーーーーー
                    
                } // ScrollView
                
            } // MARK: END - VStack
            .onAppear {
                Task {
                    if let lostInfo = await lostInfoViewModel.getLostInfo() {
                        DispatchQueue.main.async {
                            self.lostInfo = lostInfo
                        }
                    } else {
                        errMsg = await lostInfoViewModel.errorString
                    }
                }
            }
            .background(Color.gray.opacity(0.2))
            
//        }
//        .padding(EdgeInsets(top:0,leading: -5,bottom: -20,trailing:-5))
    }
    // 日時を日本形式で表示するためのDateFormatter
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
        return formatter
    }
}

struct LostInfo: Codable, Identifiable {
    var id: UUID
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    
    init(latitude: Double, longitude: Double, timestamp: Date) {
        self.id = UUID()
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }
}

#Preview {
    LostInfoView()
}
