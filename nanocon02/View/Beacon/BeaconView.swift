//
//  BeaconView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/12.
//

import SwiftUI

struct BeaconView: View {
    @EnvironmentObject private var beaconReceiver: BeaconReceiver
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Beacon History (Last 5)")
                .font(.headline)

            List(beaconReceiver.beaconHistory, id: \.self) { history in
                Text(history)
                    .font(.body)
                    .foregroundColor(.gray)
            }
            
            Text("latest")
        }
        .padding()
    }
}

#Preview {
    // 中身を見るにはMockが必要
    BeaconView()
        .environmentObject(BeaconReceiver())
}
