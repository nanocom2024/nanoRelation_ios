//
//  MyQrCodeView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/24.
//

import SwiftUI
import QRCode

struct MyQrCodeView: View {
    @State private var qrCodeImage: UIImage? = nil
    @State private var name: String? = nil
    
    @ObservedObject var myQrCodeViewModel = MyQrCodeViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // QRコード表示エリア
            if let qrCodeImage = qrCodeImage {
                Image(uiImage: qrCodeImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300) // QRコードサイズを調整
                    .padding()
                    .background(Color.white) // 背景を白にしてQRコードを際立たせる
                    .cornerRadius(16)
                    .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
            } else {
                VStack {
                    ProgressView() // ローディングインジケーター
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .scaleEffect(1.5)
                    
                    Text("QRCode generating...")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
            }
            
            Spacer()
            
            // QRコードの説明文
            Text("このQRコードをスキャンして友達追加")
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
            
            Text("ユーザー名：\(name ?? "")")
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
            
            if !myQrCodeViewModel.errorString.isEmpty {
                Text(myQrCodeViewModel.errorString)
                    .foregroundColor(.red)
            }
            
            Spacer()
        }
        .padding()
//        .background(Color(UIColor.systemGroupedBackground)) // 全体背景色
        .onAppear {
            Task {
                await generateQRCode()
            }
        }
    }
    
    private func generateQRCode() async {
        do {
            // QRコードを生成
            guard let data = await myQrCodeViewModel.getData() else {
                return
            }
            let doc = try QRCode.Document(utf8String: data)
            doc.errorCorrection = .high
            doc.design.style.backgroundFractionalCornerRadius = 3.0
            
            let cgImage = try doc.cgImage(CGSize(width: 1000, height: 1000))
            qrCodeImage = UIImage(cgImage: cgImage)
            
            name = data.components(separatedBy: ",")[1]
        } catch {
            print("QRCode generate error: \(error)")
        }
    }
}

#Preview {
    MyQrCodeView()
}
