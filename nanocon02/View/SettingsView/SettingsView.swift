//
//  SettingsView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/08.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @EnvironmentObject var navigationModel: NavigationModel
    
    var body: some View {
        NavigationStack {
            List {
                // ログアウトボタン
                Button(action: {
                    settingsViewModel.signout()
                    navigationModel.path.removeLast(navigationModel.path.count)
                }) {
                    Text("ログアウト")
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                // デバイスを探すボタン
                Button(action: {
                    navigationModel.path.append("search device")
                }) {
                    HStack {
                        Text("デバイスを探す")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 7, height: 14)
                            .foregroundColor(Color.gray.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                }

                // デバッグ用リンク
                NavigationLink(destination: DebugView()) {
                    Text("デバッグ用")
                }

//                 アカウント削除セクション
                Section {
                    ZStack {
                        NavigationLink(destination: DeleteView().environmentObject(navigationModel)) {
                            EmptyView()
                        }
                        .opacity(0) // 非表示にする
                        HStack {
                            Text("アカウント削除")
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.red)
                }
            }
            .navigationTitle("設定")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(NavigationModel())
}
