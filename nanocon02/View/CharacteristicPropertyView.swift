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
    @StateObject var bleObj: BleCommViewModel
    @State private var showAlert = false
    @State private var showError = false
    @EnvironmentObject private var navigationModel: NavigationModel
    
    var body: some View {
        
        Text("Chars: \(oneChar.characteristicName)")
        Text(" \(oneChar.uuid.uuidString)")
        
        Spacer().frame(height: 20)
        
        VStack (alignment: .center) {
            Spacer().frame(height: 20)
            
            // MARK: - pairing
            if isCharsReadable() && isCharsWriteable() {
                HStack(alignment: .center) {
                    
                    Spacer().frame(width: 10)
                    Button(action: {
                        // read
                        oneDevPeri.userPeripheral.readValue(for: oneChar.characteristic)
                        
                    }) {
                        Text("Pairing (initialized setting)")
                            .padding()
                            .frame(width: 200.0, height: 40.0)
                            .foregroundColor(Color.white)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    
                }
                
                Spacer()
                
            } else {
                Text("cannot pairing")
            }
            // MARK: - END pairing

        }
        // read event
        .onReceive(bleObj.$recValueData) { newVal in
            // read
            guard let recData = newVal else {
                print("Received nil data")
                return
            }
            
            if let valStr = String(data: recData, encoding: .utf8) {
                print("Received value: \(valStr)")
            } else {
                print("Failed to decode data")
            }
            
            // write
            if oneDevPeri.userPeripheral.state != CBPeripheralState.connected {
                showAlert = true
            } else {
                // 文字列をDataに変換して書き込む
                let writeString = "a,b,2,3"
                if let dataToWrite = writeString.data(using: .utf8) {
                    oneDevPeri.userPeripheral.writeValue(dataToWrite, for: oneChar.characteristic, type: .withResponse)
                } else {
                    showError = true
                }
            }
            
        }
        // write success event
        .onChange(of: bleObj.initWriteSuccess) { _, newValue in
            if newValue {
                navigationModel.path.append("device pairing success")
                bleObj.initWriteSuccess = false
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
//    CharacteristicPropertyView()
//}

