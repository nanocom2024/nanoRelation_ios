//
//  DebugView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/22.
//

import SwiftUI

struct DebugView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    
    var body: some View {
        VStack {
            Text(Auth.getToken() ?? "token not found")
            
            Spacer()
            
            Button(action: {
                navigationModel.path.append("beacon")
            }, label: {
                Text("iBeacon receive")
            })
            
            Spacer().frame(height: 20)
            
            Button(action: {
                navigationModel.path.append("street pass")
            }, label: {
                Text("street pass")
            })
            
            Spacer()
        }
    }
}

#Preview {
    DebugView()
        .environmentObject(NavigationModel())
}
