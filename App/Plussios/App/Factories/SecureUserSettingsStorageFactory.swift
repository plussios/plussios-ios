//
//  SecureUserSettingsStorageFactory.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation
import PlussiosCore

final class SecureUserSettingsStorageFactory {
    // Shared instance
    static let shared = SecureUserSettingsStorageFactory()

    func make() -> SecureUserSettingsStorageProtocol {
        SecureUserSettingsStorage(keychain: Keychain())
    }
}
