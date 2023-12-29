//
//  PlussiosGSheetClient.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public protocol PlussiosGSheetClientProtocol {
    func loadCurrentBudget(sheetId: GSheetId) async throws -> BudgetTotals
}

public final class PlussiosGSheetClient: PlussiosGSheetClientProtocol {
    private enum Constants {
        static let currentBudgetSheetName = "BudgetNow"
    }

    private let gSheetClient: GSheetsClientProtocol
    private let currentBudgetMapper: CurrentBudgetEntriesMapperProtocol

    public init(
        gSheetClient: GSheetsClientProtocol,
        currentBudgetMapper: CurrentBudgetEntriesMapperProtocol = CurrentBudgetEntriesMapper()
    ) {
        self.gSheetClient = gSheetClient
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
}
