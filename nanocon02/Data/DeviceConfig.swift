//
//  DeviceConfig.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/11.
//

import Foundation
import CoreBluetooth

class DeviceConfig {
    static let init_service_uuid = CBUUID(string: "AAAAAAAA-8883-49A8-8BDB-42BC1A7107F4")
    static let init_characteristic_uuid = CBUUID(string: "BBBBBBBB-201F-44EB-82E8-10CC02AD8CE1")
    
    static let iBeacon_uuid = "e2c56db5dffb48d2b060d0f5a71096e0"
}
