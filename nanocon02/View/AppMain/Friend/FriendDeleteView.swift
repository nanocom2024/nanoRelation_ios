//
//  FriendDeleteView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/24.
//

import SwiftUI

struct FriendDeleteView: View {
    let oneFriend: Friend
    
    @Environment(\.dismiss) var dismiss
    @State private var isDeleting = false // 削除中状態を管理
    
    @ObservedObject private var friendDeleteViewModel = FriendDeleteViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // ヘッダー
            Text("友達を削除しますか？")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
            
            // 対象友達の名前を表示
            Text("ユーザー名：\(oneFriend.name)")
                .font(.headline)
                .foregroundColor(.secondary)
            
            // 削除確認ボタン群
            HStack {
                // キャンセルボタン
                Button(action: {
                    dismiss()
                }) {
                    Text("キャンセル")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(8)
                }
                
                // 削除ボタン
                Button(action: {
                    isDeleting = true
                    
                    // 削除処理を実行
                    Task {
                        await friendDeleteViewModel.deleteFriend(friend_uid: oneFriend.id, name_id: oneFriend.name_id)
                        isDeleting = false
                        dismiss()
                    }
                    
                }) {
                    if isDeleting {
                        ProgressView() // 削除中のローディング表示
                            .scaleEffect(1.5)
                    } else {
                        Text("削除する")
                            .font(.headline)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground)) // 背景をシステム標準色に
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
    }
}

#Preview {
    FriendDeleteView(oneFriend: Friend(id: "test", name: "テストユーザー", name_id: "#1234"))
}
