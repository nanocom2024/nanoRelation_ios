//
//  HomeView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/10.
//

import SwiftUI

struct HomeView: View {
    // 認証結果を保持する状態プロパティ
    @State private var isAuthenticated: Bool = false
    @ObservedObject private var beaconReceiver = BeaconReceiver()
    @EnvironmentObject private var navigationModel: NavigationModel

    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            Group {
                // isAuthenticatedの状態に応じて表示するViewを切り替える
                if isAuthenticated {
                } else {
                    ProgressView("Checking authentication...") // 認証中のインジケーター
                }
            }
            .navigationDestination(for: String.self) { value in
                switch value {
                case "login":
                    LoginView()
                case "test":
                    TestView()
                case "search device":
                    SearchDeviceView()
                        .environmentObject(BleCommViewModel())
                case "device pairing success":
                    DevicePairingSuccessView()
                case "beacon":
                    BeaconView()
                        .environmentObject(beaconReceiver)
                case "street pass":
                    StreetPassView()
                        .environmentObject(beaconReceiver)
                default:
                    Text("Unknown destination")
                }
            }
        }
        .onAppear {
            // ビューが表示されたタイミングで認証を確認
            authCheck()
        }
        // ナビゲーションパスが空になった場合に再度認証チェックを実行
        .onChange(of: navigationModel.path.count) { _, newCount in
            if newCount == 0 {
                authCheck()
            }
        }
    }

    private func authCheck() {
        Auth.auth_check { res in
            // 認証結果に応じてisAuthenticatedを更新
            DispatchQueue.main.async {
                if res {
                    isAuthenticated = true
                    navigationModel.path.append("test")
                    isAuthenticated = false
                } else {
                    isAuthenticated = false
                    navigationModel.path.append("login")
                    isAuthenticated = false
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationModel())
}

