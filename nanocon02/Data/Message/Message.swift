//
//  Message.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/21.
//

import Foundation
import SwiftUI

// メッセージの構造体
struct Message: Identifiable {
    let id: UUID
    let text: String
    let color: Color
    let date: Date  // メッセージの日時
    
    init(id: UUID = UUID(), text: String, color: Color, date: Date) {
        self.id = id
        self.text = text
        self.color = color
        self.date = date
    }
}
