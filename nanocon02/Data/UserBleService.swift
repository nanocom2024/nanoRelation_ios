//
//  UserBleService.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/11.
//

import CoreBluetooth

class UserBleService: Identifiable, ObservableObject {
    
    var id: UUID
    var uuid: CBUUID
    var service: CBService
    var serviceName: String
    var userCharacteristics: [UserBleCharacteristic] = []
    
    init(_uuid: CBUUID, _service: CBService, _serviceName: String, _userCharacteristics: [UserBleCharacteristic]) {
        id = UUID()
        uuid = _uuid
        service = _service
        serviceName = _serviceName
        userCharacteristics = _userCharacteristics
    }
}
