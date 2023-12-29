//
//  Assembly.swift
//  PlussiosWidgetExtension
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation
import PlussiosCore

final class Assembly {
    // Shared instance
    static let shared = Assembly()

    let keychain: KeychainProtocol
    let userSettingsStorage: SecureUserSettingsStorageProtocol
    let gSheetsClient: GSheetsClientProtocol
    let plussiosClient: PlussiosClientProtocol

    private init() {
        keychain = Keychain()
        userSettingsStorage = SecureUserSettingsStorage(keychain: keychain)
        gSheetsClient = GSheetsClient(apiKey: Secrets.shared.gSheetsApiKey)
//        plussiosClient = PlussiosGSheetClient(gSheetClient: gSheetsClient)
        plussiosClient = PlussiosApiClient()
    }
}
