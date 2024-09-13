//
//  ExpenseTotalsRepositoryProtocol.swift
//  PlussiosCore
//
//  Created by Stan Sidel on 9/13/24.
//

import Foundation

public protocol ExpenseTotalsRepositoryProtocol {
    func loadCurrentExpenses(period: ExpensesPeriod) async throws -> ExpensesTotals
}
