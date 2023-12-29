//
//  Item.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
