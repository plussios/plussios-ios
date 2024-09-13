//
//  ExpenseTotalsRepositoryFactory.swift
//  Plussios
//
//  Created by Stan Sidel on 9/13/24.
//

import PlussiosCore

final class ExpenseTotalsRepositoryFactory {
    // Shared instance
    static let shared = ExpenseTotalsRepositoryFactory()

    func make() -> ExpenseTotalsRepositoryProtocol {
        PlussiosApiClient(userSettingsStorage: SecureUserSettingsStorageFactory.shared.make())
    }
}
