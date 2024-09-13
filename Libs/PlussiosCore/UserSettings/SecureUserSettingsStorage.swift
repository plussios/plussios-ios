//
//  SecureUserSettingsStorage.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public protocol SecureUserSettingsStorageProtocol {
    func save(_ userSettings: SecureUserSettings) async throws
    func load() async throws -> SecureUserSettings?
}

public final class SecureUserSettingsStorage: SecureUserSettingsStorageProtocol {
    private let keychainKey: String = "SecureUserSettings"
    
    private let keychain: KeychainProtocol
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    public init(keychain: KeychainProtocol) {
        self.keychain = keychain
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }
    
    public func save(_ userSettings: SecureUserSettings) async throws {
        let data = try encoder.encode(userSettings)

        try await keychain.save(data, forKey: keychainKey)
    }
    
    public func load() async throws -> SecureUserSettings? {
        guard let data = try await keychain.load(keychainKey) else {
            return nil
        }
        
        return try decoder.decode(SecureUserSettings.self, from: data)
    }
}
