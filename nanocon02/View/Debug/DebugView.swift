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
            
            Spacer().frame(height: 20)
            
            Button(action: {
                navigationModel.path.append("pairing table")
            }, label: {
                Text("pairing table")
            })
            
            Spacer().frame(height: 20)
            
            Button(action: {
                navigationModel.path.append("friend table")
            }, label: {
                Text("friend table")
            })
            
            Spacer().frame(height: 20)
            
            Button(action: {
                navigationModel.path.append("pass table")
            }, label: {
                Text("pass table")
            })
            
            Spacer().frame(height: 20)
            
            Button(action: {
                navigationModel.path.append("lost pass table")
            }, label: {
                Text("lost pass table")
            })
            
            Spacer()
        }
    }
}

#Preview {
    DebugView()
        .environmentObject(NavigationModel())
}
