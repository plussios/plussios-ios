//
//  PlussiosGSheetClient.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public final class PlussiosGSheetClient {
    private enum Constants {
        static let currentBudgetSheetName = "BudgetNow"
    }

    private let gSheetClient: GSheetsClientProtocol
    private let userSettingsStorage: SecureUserSettingsStorageProtocol
    private let currentBudgetMapper: CurrentBudgetEntriesMapperProtocol

    public init(
        gSheetClient: GSheetsClientProtocol,
        userSettingsStorage: SecureUserSettingsStorageProtocol,
        currentBudgetMapper: CurrentBudgetEntriesMapperProtocol = CurrentBudgetEntriesMapper()
    ) {
        self.gSheetClient = gSheetClient
        self.userSettingsStorage = userSettingsStorage
        self.currentBudgetMapper = currentBudgetMapper
    }

    public func loadCurrentBudget(sheetId: GSheetId) async throws -> BudgetTotals {
        let values = try await gSheetClient.fetchSheetData(
            sheetId,
            SheetFullRange(sheetName: Constants.currentBudgetSheetName)
        )

        let entries = try await currentBudgetMapper.mapFromGSheet(values)

        return BudgetTotals(date: Date(), entries: entries)
    }

    public func loadCurrentExpenses(sheetId: GSheetId, period: ExpensesPeriod) async throws -> ExpensesTotals {
        throw GeneralError.notImplemented
    }

    private func getSheetId() async throws -> GSheetId {
        guard let settings = try await userSettingsStorage.load(),
              let sheetId = settings.sheetId
        else {
            throw PlussiosApiClientError.missingSheetId
        }

        return sheetId
    }
}

extension PlussiosGSheetClient: ExpenseTotalsRepositoryProtocol {

    public func loadCurrentExpenses(period: ExpensesPeriod) async throws -> ExpensesTotals {
        let sheetId = try await getSheetId()
        return try await loadCurrentExpenses(sheetId: sheetId, period: period)
    }
}

extension PlussiosGSheetClient: BudgetRepositoryProtocol {

    public func loadCurrentBudget() async throws -> BudgetTotals {
        let sheetId = try await getSheetId()
        return try await loadCurrentBudget(sheetId: sheetId)
    }
}
