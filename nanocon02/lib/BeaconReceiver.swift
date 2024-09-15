//
//  BeaconReceiver.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/12.
//

import Foundation
import CoreLocation

class BeaconReceiver: NSObject, CLLocationManagerDelegate, ObservableObject {
    var locationManager: CLLocationManager!
    var beaconRegion: CLBeaconRegion!

    @Published var beaconHistory: [String] = []
    @Published var latestBeaconInfo: BeaconInfo?

    override init() {
        super.init()

        // CLLocationManagerの初期化
        locationManager = CLLocationManager()
        locationManager.delegate = self

        // 位置情報使用許可をリクエスト（必須）
        locationManager.requestWhenInUseAuthorization()

        // iBeaconのUUIDを設定（ここでは例としてUUIDを設定）
        beaconRegion = CLBeaconRegion(uuid: DeviceConfig.iBeacon_uuid, identifier: "MyBeacon")

        // レンジング（ビーコンとの距離測定）を開始
        locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: DeviceConfig.iBeacon_uuid))
    }
}

// CLLocationManagerDelegateメソッド
extension BeaconReceiver {
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            var proximityString: String

            switch beacon.proximity {
            case .immediate:
                proximityString = "Very Close"
            case .near:
                proximityString = "Near"
            case .far:
                proximityString = "Far Away"
            default:
                proximityString = "Unknown"
            }

            latestBeaconInfo = BeaconInfo(
                proximity: proximityString,
                major: beacon.major.stringValue,
                minor: beacon.minor.stringValue,
                rssi: beacon.rssi
            )

            // ビーコンの詳細情報
            let beaconInfo = "Proximity: \(proximityString),\nMajor: \(beacon.major), Minor: \(beacon.minor), RSSI: \(beacon.rssi)"

            self.beaconHistory.append(beaconInfo)
            if self.beaconHistory.count > 5 {
                self.beaconHistory.removeFirst(self.beaconHistory.count - 5) // 最新5つのみ保持
            }

        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}

struct BeaconInfo: Equatable {
//    var id: UUID = UUID()
    var proximity: String
    var major: String
    var minor: String
    var rssi: Int
}
