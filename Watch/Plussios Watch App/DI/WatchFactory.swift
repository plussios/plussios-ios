//
//  WatchFactory.swift
//  Plussios
//
//  Created by Stan Sidel on 9/15/24.
//

import Factory

import PlussiosCore

extension Container {

    var budgetRepository: Factory<BudgetRepositoryProtocol> {
        self { self.apiClient() }
    }

    var watchSettings: Factory<WatchSettings> {
        self { WatchSettings() }
            .singleton
    }

    private var keychain: Factory<KeychainProtocol> {
        self { Keychain() }
    }

    var userSettingsStorage: Factory<SecureUserSettingsStorageProtocol> {
        self { SecureUserSettingsStorage(keychain: self.keychain()) }
            .singleton
    }

    private var apiClient: Factory<PlussiosApiClient> {
        self { PlussiosApiClient(userSettingsStorage: self.userSettingsStorage()) }
    }
}
