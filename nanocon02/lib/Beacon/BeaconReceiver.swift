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
    @Published var currentLocation: CLLocation? // 最新の位置情報


    override init() {
        super.init()

        // CLLocationManagerの初期化
        locationManager = CLLocationManager()
        locationManager.delegate = self

        // 位置情報使用許可をリクエスト（必須）
        locationManager.requestWhenInUseAuthorization()
        
        // 位置情報の更新を開始
        locationManager.startUpdatingLocation() // 位置情報取得の開始

        // iBeaconのUUIDを設定（ここでは例としてUUIDを設定）
        beaconRegion = CLBeaconRegion(uuid: DeviceConfig.iBeacon_uuid, identifier: "MyBeacon")

        // レンジング（ビーコンとの距離測定）を開始
        start_ranging()
    }
}

// CLLocationManagerDelegateメソッド
extension BeaconReceiver {
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        for beacon in beacons {
            
            Task {
                let proximityString: String

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
                
                let location = currentLocation
                let latitude = location?.coordinate.latitude
                let longitude = location?.coordinate.longitude

                DispatchQueue.main.async {
                    self.latestBeaconInfo = BeaconInfo(
                        proximity: proximityString,
                        major: beacon.major.stringValue,
                        minor: beacon.minor.stringValue,
                        rssi: beacon.rssi,
                        latitude: latitude,
                        longitude: longitude
                    )
                }

                // ビーコンの詳細情報
                let beaconInfo = "Proximity: \(proximityString),\nMajor: \(beacon.major), Minor: \(beacon.minor), RSSI: \(beacon.rssi)"

                DispatchQueue.main.async {
                    self.beaconHistory.append(beaconInfo)
                    if self.beaconHistory.count > 5 {
                        self.beaconHistory.removeFirst(self.beaconHistory.count - 5) // 最新5つのみ保持
                    }
                }
            }

        }
    }
    
    // 位置情報の更新が行われたときに呼ばれるメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 最新の位置情報を取得
        if let location = locations.last {
            currentLocation = location
        }
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    func start_ranging() {
        // レンジング（ビーコンとの距離測定）を開始
        locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: DeviceConfig.iBeacon_uuid))
    }
    
    func stop_ranging() {
        locationManager.stopRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: DeviceConfig.iBeacon_uuid))
    }
}

struct BeaconInfo: Equatable {
//    var id: UUID = UUID()
    var proximity: String
    var major: String
    var minor: String
    var rssi: Int
    var latitude: Double? // 緯度
    var longitude: Double? // 経度
}
