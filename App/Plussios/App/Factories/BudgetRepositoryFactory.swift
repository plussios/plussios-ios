//
//  BudgetRepositoryFactory.swift
//  Plussios
//
//  Created by Stan Sidel on 9/13/24.
//

import PlussiosCore

final class BudgetRepositoryFactory {
    // Shared instance
    static let shared = BudgetRepositoryFactory()

    func make() -> BudgetRepositoryProtocol {
        PlussiosApiClient(userSettingsStorage: SecureUserSettingsStorageFactory.shared.make())
    }
}
