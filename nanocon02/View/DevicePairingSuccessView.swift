//
//  DevicePairingSuccessView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/11.
//

import SwiftUI

struct DevicePairingSuccessView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    
    var body: some View {
        Group {
            Spacer()
            
            Text("The device initialization is complete")
            
            Spacer().frame(height: 50)
            
            Button(action: {
                navigationModel.path.removeLast()
            }, label: {
                Text("home")
            })
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DevicePairingSuccessView()
}
