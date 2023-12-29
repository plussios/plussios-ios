//
//  SecureUserSettings.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public struct SecureUserSettings: Codable {
    public var sheetId: GSheetId?

    public init(sheetId: GSheetId? = nil) {
        self.sheetId = sheetId
    }
}
