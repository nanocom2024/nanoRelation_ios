//
//  DetailView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/11.
//

import SwiftUI
import CoreBluetooth

struct DeviceDetailView: View {
    
    @StateObject public var oneDev: UserBlePeripheral
    @State var connectionStatus: String = "Connecting ..."
    @EnvironmentObject private var navigationModel: NavigationModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var bleViewModel: BleCommViewModel
    
    var body: some View {
        Group {
            Text(oneDev.name)
            Spacer().frame(height: 20)
            
            if oneDev.userPeripheral.state == CBPeripheralState.connected {
                Text("connected")
                
                ServiceListView()
                    .environmentObject(bleViewModel)
                    .environmentObject(navigationModel)
            } else {
                Text("\(connectionStatus)")
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: goBack) {
                    Text("Back")
                        .padding()
                        .frame(width: 80.0, height: 30.0)
                        .foregroundColor(Color.white)
                        .background(Color.purple)
                        .cornerRadius(8)
                }
        )
        .onAppear {
            if oneDev.userPeripheral.state != CBPeripheralState.connected {
                bleViewModel.centralManager?.connect(oneDev.userPeripheral)
            }
            if oneDev.userPeripheral.state != CBPeripheralState.connected {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if oneDev.userPeripheral.state != CBPeripheralState.connected {
                        connectionStatus = "Cannot connect"
                    }
                }
            }
        }
        .onDisappear {
            bleViewModel.centralManager?.cancelPeripheralConnection(oneDev.userPeripheral)
        }
    }
    
    func goBack() {
        self.dismiss()
        bleViewModel.centralManager?.cancelPeripheralConnection(oneDev.userPeripheral)
    }
}

struct ServiceListView: View {
    @EnvironmentObject private var bleViewModel: BleCommViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    var body: some View {
        ForEach(bleViewModel.connectedUserBlePeripheral?.userServices ?? []) { service in
            ServiceView(service: service)
                .environmentObject(bleViewModel)
                .environmentObject(navigationModel)
        }
    }
}
    
struct ServiceView: View {
    @EnvironmentObject private var bleViewModel: BleCommViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    var service: UserBleService
    
    var body: some View {
        GroupBox(
            label: VStack {
                Text("Service: \(service.serviceName)")
                Text("\(service.uuid.uuidString)").font(.subheadline)
            }
        ) {
            ForEach(service.userCharacteristics) { userChar in
                if let connectedUserBlePeripheral = bleViewModel.connectedUserBlePeripheral {
                    Divider().padding(.vertical, 2)
                    CharacteristicNavigationLink(userChar: userChar, service: service, peripheral: connectedUserBlePeripheral)
                        .environmentObject(bleViewModel)
                        .environmentObject(navigationModel)
                } else {
                    Text("No connected device")
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue, lineWidth: 1)
        )
        .padding(.horizontal, 10)
    }
}

struct CharacteristicNavigationLink: View {
    @EnvironmentObject private var bleViewModel: BleCommViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    var userChar: UserBleCharacteristic
    var service: UserBleService
    var peripheral: UserBlePeripheral

    var body: some View {
        NavigationLink(
            destination: CharacteristicPropertyView(
                oneChar: userChar,
                oneDevPeri: peripheral,
                oneService: service
            )
            .environmentObject(bleViewModel)
            .environmentObject(navigationModel)
        ) {
            CharacteristicCell(
                oneChar: userChar
            )
        }
    }
}

struct CharacteristicCell: View {
    @ObservedObject var oneChar: UserBleCharacteristic
    
    var body: some View {
        LabeledContent {
            
            HStack {
//                    Image(systemName: "arrow.right.circle")
            }
            
        } label: {
            
            Text("Chars: \(oneChar.characteristicName)")
            Text(oneChar.uuid.uuidString)
            
        }
        .font(.subheadline)
        
    }
}

//#Preview {
//    // previewを見れるようにするにはMockが必要
//    DeviceDetailView()
//}

