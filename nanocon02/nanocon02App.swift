//
//  nanocon02App.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/23.
//

import SwiftUI

@main
struct nanocon02App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(NavigationModel())
        }
    }
}
