//
//  FriendAdd.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/24.
//

import SwiftUI

struct FriendAddView: View {
    @State private var scannedResult: String = ""
    @State private var code: String = ""
    
    @ObservedObject private var friendAddViewModel = FriendAddViewModel()
    @EnvironmentObject private var navigationModel: NavigationModel
    
    var body: some View {
        VStack(spacing: 20) { // 各要素間の余白を設定
            // カメラビュー
            FriendAddScannerView(scanInterval: 1.0) { result in
                if scannedResult.isEmpty {
                    let data = result.split(separator: ",")
                    code = String(data[0])
                    let name = data[1]
                    scannedResult = String(name)
                    print("Scanned QR code: \(result)")
                }
            }
            .frame(height: 400) // カメラビューの高さ
            .cornerRadius(16) // カメラビューに角丸を適用
            .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5) // 影を追加
            .padding(.horizontal, 20) // 左右に余白
            
            // コンテンツエリア
            VStack(spacing: 16) {
                // スキャン結果表示
                if scannedResult.isEmpty {
                    Text("QRコードをスキャンしてください")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Text("スキャン結果: \(scannedResult)")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                // 友達追加ボタン
                if !scannedResult.isEmpty && !code.isEmpty {
                    Button(action: {
                        Task {
                            let res = await friendAddViewModel.addFriend(code: code)
                            if res {
                                FriendDatastore.shared?.syncFriends()
                                navigationModel.path.removeLast()
                            }
                            
                            code = ""
                            scannedResult = ""
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus.app.fill")
                                .font(.system(size: 20)) // アイコンサイズ
                            Text("友達追加")
                                .font(.headline) // フォントを設定
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity) // ボタンを画面幅に広げる
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20) // 左右に余白
                    .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                
                // マイQRコード表示ボタン
                Button(action: {
                    navigationModel.path.append("myQR")
                }) {
                    HStack {
                        Image(systemName: "qrcode")
                            .font(.system(size: 20))
                        Text("マイQRコードを表示")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .shadow(color: .green.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.top, 20)
        }
//        .background(Color(UIColor.systemGroupedBackground)) // 背景色を設定
//        .edgesIgnoringSafeArea(.bottom) // 背景を下まで広げる
    }
}

#Preview {
    FriendAddView()
}
