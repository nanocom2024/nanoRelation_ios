//
//  StreetPassView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/14.
//

import SwiftUI

struct StreetPassView: View {
    @EnvironmentObject private var beaconReceiver: BeaconReceiver
    @StateObject private var streetPassViewModel = StreetPassViewModel()
    @State private var history: [String] = []
    @State private var errString = ""

    var body: some View {
        VStack {
            Text("すれ違い状況の確認")
            Spacer().frame(height: 20)
            if history.isEmpty {
                Text("No data")
            } else {
                List(history, id: \.self) { val in
                    Text(val)
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
            if errString != "" {
                Spacer().frame(height: 20)
                
                Text(errString)
                    .foregroundStyle(Color.red)
            }
        }
        .onChange(of: beaconReceiver.latestBeaconInfo) { _, newInfo in
            print("change info")
            if let info = newInfo {
                Task {
                    await streetPassViewModel.received_beacon(info: info)
                }
            }
        }
        .onChange(of: streetPassViewModel.receivedHistory) { _, newVal in
            history.append(newVal)
            if self.history.count > 5 {
                self.history.removeFirst(self.history.count - 5) // 最新5つのみ保持
            }
        }
        .onChange(of: streetPassViewModel.errorString) { _, newErr in
            errString = newErr
        }
    }
}

#Preview {
    StreetPassView()
        .environmentObject(BeaconReceiver())
}
