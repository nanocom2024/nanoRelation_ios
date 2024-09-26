//
//  CharacteristicPropertyView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/11.
//

import SwiftUI
import Foundation
import CoreBluetooth

struct CharacteristicPropertyView: View {
    
    @StateObject public var oneChar: UserBleCharacteristic
    @StateObject public var oneDevPeri: UserBlePeripheral
    @StateObject public var oneService: UserBleService
    @StateObject private var CharPropertyObj = CharacteristicPropertyViewModel()
    @State private var showAlert = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isPairingButtonDisabled = false
    @EnvironmentObject private var navigationModel: NavigationModel
    @EnvironmentObject var bleObj: BleCommViewModel
    
    var body: some View {
        
        Text("Chars: \(oneChar.characteristicName)")
        Text(" \(oneChar.uuid.uuidString)")
        
        Spacer().frame(height: 20)
        
        VStack (alignment: .center) {
            Spacer().frame(height: 20)
            
            if errorMessage != "" {
                Text(errorMessage)
                    .foregroundStyle(Color.red)
            }
            
            // MARK: - pairing
//            if isCharsReadable() && isCharsWriteable() {
                HStack(alignment: .center) {
                    
                    Spacer().frame(width: 10)
                    
                    if isPairingButtonDisabled && !CharPropertyObj.errorString.isEmpty {
                        ProgressView("initializing device...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else {
                        Button(action: {
                            isPairingButtonDisabled = true
                            CharPropertyObj.errorString = ""
                            
                            // read
                            for oneCh in oneService.userCharacteristics {
                                if oneCh.uuid == DeviceConfig.init_characteristic_read_uuid {
                                    oneDevPeri.userPeripheral.readValue(for: oneCh.characteristic)
                                }
                            }
                            
                        }) {
                            Text("Pairing (initialize setting)")
                                .padding()
                                .frame(width: 240.0, height: 40.0)
                                .foregroundColor(Color.white)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                        .disabled(isPairingButtonDisabled)
                    }
                    
                }
                
                Spacer()
                
//            } else {
//                Text("cannot pairing")
//            }
            // MARK: - END pairing
            
        }
        // read event
        .onReceive(bleObj.$recValueData) { newVal in
            // read
            guard let recData = newVal else {
                print("Received nil data")
                //                errorMessage = "Received nil data"
                isPairingButtonDisabled = false
                return
            }
            
            guard let device_id = String(data: recData, encoding: .utf8) else {
                print("Failed to decode data")
                errorMessage = "Failed to decode data"
                isPairingButtonDisabled = false
                return
            }
            
            // write
            if oneDevPeri.userPeripheral.state != CBPeripheralState.connected {
                showAlert = true
            } else {
                Task {
                    // 文字列をDataに変換して書き込む
                    let writeString = await CharPropertyObj.generate_writeString(device_id: device_id)
                    if let dataToWrite = writeString?.data(using: .utf8) {
                        for oneCh in oneService.userCharacteristics {
                            if oneCh.uuid == DeviceConfig.init_characteristic_write_uuid {
                                oneDevPeri.userPeripheral.writeValue(dataToWrite, for: oneChar.characteristic, type: .withResponse)
                            }
                        }
                        
                    } else {
                        isPairingButtonDisabled = false
                        errorMessage = CharPropertyObj.errorString
                    }
                    
                }
            }
            
        }
        // write success event
        .onChange(of: bleObj.initWriteSuccess) { _, newValue in
            if newValue {
                Auth.auth_check { ok in
                    // 認証で問題がなければ次のViewへ
                    DispatchQueue.main.async {
                        if ok {
                            bleObj.centralManager?.cancelPeripheralConnection(oneDevPeri.userPeripheral)
                            bleObj.stopScanning()
                            bleObj.initWriteSuccess = false
                            navigationModel.path.removeLast(1)
                            // next View
                            navigationModel.path.append("device pairing success")
                            isPairingButtonDisabled = false
                        } else {
                            navigationModel.path.removeLast(navigationModel.path.count)
                            bleObj.initWriteSuccess = false
                            isPairingButtonDisabled = false
                        }
                    }
                }
            }
        }
        .alert("Device disconnected", isPresented: $showAlert){
            
        }
        
        Spacer()
    }
    
    func isCharsReadable() -> Bool {
        if (oneChar.characteristic.properties.rawValue &
            CBCharacteristicProperties.read.rawValue) == 0 {
            return false
        } else {
            return true
        }
    }
    
    func isCharsWriteable() -> Bool {
        if (oneChar.characteristic.properties.rawValue &
            CBCharacteristicProperties.write.rawValue) == 0 {
            return false
        } else {
            return true
        }
    }
    
}

//#Preview {
//    // previewを見れるようにするにはMockが必要
//    CharacteristicPropertyView()
//}

