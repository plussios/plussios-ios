//
//  AppFactory.swift
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

    var expenseTotalsRepository: Factory<ExpenseTotalsRepositoryProtocol> {
        self { self.apiClient() }
    }

    private var keychain: Factory<KeychainProtocol> {
        self { Keychain() }
    }

    var userSettingsStorage: Factory<SecureUserSettingsStorageProtocol> {
        self { SecureUserSettingsStorage(keychain: self.keychain()) }
    }

    private var apiClient: Factory<PlussiosApiClient> {
        self { PlussiosApiClient(userSettingsStorage: self.userSettingsStorage()) }
    }

    var watchConnector: Factory<WatchConnectorProtocol> {
        self { WatchConnector.shared }
    }

    var gSheetClient: Factory<GSheetsClientProtocol> {
        self { GSheetsClient(apiKey: Secrets.shared.gSheetsApiKey) }
    }
}
