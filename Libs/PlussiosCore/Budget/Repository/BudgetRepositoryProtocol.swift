//
//  BudgetRepositoryProtocol.swift
//  PlussiosCore
//
//  Created by Stan Sidel on 9/13/24.
//

import Foundation

public protocol BudgetRepositoryProtocol {
    func loadCurrentBudget() async throws -> BudgetTotals
}
