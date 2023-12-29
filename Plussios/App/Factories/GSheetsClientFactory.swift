//
//  GSheetsClientFactory.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation
import PlussiosCore

final class GSheetsClientFactory {
    // Shared instance
    static let shared = GSheetsClientFactory()

    func makeClient() -> GSheetsClient {
        let client = GSheetsClient(apiKey: Secrets.shared.gSheetsApiKey)
        return client
    }
}
