//
//  PlussiosClientProtocol.swift
//  PlussiosCore
//
//  Created by Stan Sidel on 30.12.2023.
//

import Foundation

public protocol PlussiosClientProtocol {
    func loadCurrentBudget(sheetId: GSheetId) async throws -> BudgetTotals
    func loadCurrentExpenses(sheetId: GSheetId, period: ExpensesPeriod) async throws -> ExpensesTotals
}

