//
//  Secrets.swift
//  PlussiosCore
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public final class Secrets {
    // Shared instance
    public static let shared = Secrets()
    private init() {}

    // FIXME: Use env var to get this value
    public let gSheetsApiKey = ""
}
