//
//  NotificationManager.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/18.
//

import Foundation
import UserNotifications

class NotificationManager {
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Granted: \(granted)")
            }
        }
    }
    
    
    func sendDisconnectedNotification(peripheralName: String) {
        // ローカル通知を送信
        let content = UNMutableNotificationContent()
        content.title = "BLEデバイスが切断されました"
        content.body = "\(peripheralName) との接続が切れました"
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知送信エラー: \(error)")
            }
        }
    }
}
