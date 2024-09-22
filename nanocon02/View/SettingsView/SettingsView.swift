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
        VStack {
            HStack {
                Spacer()
                Spacer()
                Button(action: {
                    settingsViewModel.signout()
                    navigationModel.path.removeLast(navigationModel.path.count)
                }, label: {
                    Text("signout")
                })
                Spacer()
            }
            
            Spacer()

            VStack {
                Spacer()

                Button(action: {
                    navigationModel.path.append("search device")
                }, label: {
                    Text("search Device")
                })

                Spacer().frame(height: 20)


                
                NavigationLink(destination: DebugView(),
                               label: {
                    Text("デバッグ用")
                })

                Spacer()

                NavigationLink(
                    destination: DeleteView()
                        .environmentObject(navigationModel),
                    label: {
                        Text("Delete Account")
                            .frame(width: 140, height: 40)
                            .font(.body)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                )
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    SettingsView()
}
