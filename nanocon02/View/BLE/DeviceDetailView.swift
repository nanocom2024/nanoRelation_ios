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
                
                ServiceListView(services: bleViewModel.connectedUserBlePeripheral?.userServices ?? [],
                                bleViewModel: _bleViewModel)
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
            bleViewModel.centralManager?.connect(oneDev.userPeripheral)
            if oneDev.userPeripheral.state != CBPeripheralState.connected {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    connectionStatus = "Cannot connect"
                }
            }
        }
    }
    
    func goBack() {
        self.dismiss()
        bleViewModel.centralManager?.cancelPeripheralConnection(oneDev.userPeripheral)
    }
}

struct ServiceListView: View {
    let services: [UserBleService]
    @EnvironmentObject var bleViewModel: BleCommViewModel

    var body: some View {
        ForEach(services) { service in
            GroupBox(
                label: VStack {
                    Text("Service: \(service.serviceName)")
                    Text("\(service.uuid.uuidString)").font(.subheadline)
                }
            ) {
                ForEach(service.userCharacteristics) { userChar in
                    Divider().padding(.vertical, 2)
                    NavigationLink(
                        destination: CharacteristicPropertyView(
                            oneChar: userChar,
                            oneDevPeri: bleViewModel.connectedUserBlePeripheral!,
                            oneService: service
                        ).environmentObject(bleViewModel)
                    ) {
                        CharacteristicCell(
                            onePeri: bleViewModel.connectedUserBlePeripheral!,
                            oneChar: userChar
                        )
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
}

struct CharacteristicCell: View {
    @ObservedObject var onePeri: UserBlePeripheral
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

