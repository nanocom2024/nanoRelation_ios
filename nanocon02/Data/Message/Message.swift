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
    let id = UUID()
    let text: String
    let color: Color
    let date: Date  // メッセージの日時
}
