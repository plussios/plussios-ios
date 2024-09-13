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
//    let gSheetsClient: GSheetsClientProtocol
    let budgetRepository: BudgetRepositoryProtocol
    let expenseTotalsRepository: ExpenseTotalsRepositoryProtocol

    private init() {
        keychain = Keychain()
        userSettingsStorage = SecureUserSettingsStorage(keychain: keychain)
//        gSheetsClient = GSheetsClient(apiKey: Secrets.shared.gSheetsApiKey)
        let apiClient = PlussiosApiClient(userSettingsStorage: userSettingsStorage)
        budgetRepository = apiClient
        expenseTotalsRepository = apiClient
    }
}
