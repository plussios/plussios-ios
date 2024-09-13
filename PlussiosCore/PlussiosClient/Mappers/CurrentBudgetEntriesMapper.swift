//
//  CurrentBudgetEntriesMapper.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public protocol CurrentBudgetEntriesMapperProtocol {
    func mapFromGSheet(_ rows: [[String]]) async throws -> [BudgetTotals.Entry]
}

public enum CurrentBudgetEntriesMapperError: Error {
    case invalidRow([String])
    case invalidDate(String)
}

public struct CurrentBudgetEntriesMapper: CurrentBudgetEntriesMapperProtocol {

    fileprivate enum Column: Int {
        case category = 0
        case balance

        static var count: Int {
            Column.balance.rawValue + 1
        }
    }

    private let categoryInfoMapper: CategoryInfoMapperProtocol
    private let moneyAmountMapper: MoneyAmountMapperProtocol

    public init(
        categoryInfoMapper: CategoryInfoMapperProtocol = CategoryInfoMapper(),
        moneyAmountMapper: MoneyAmountMapperProtocol = MoneyAmountMapper()
    ) {
        self.categoryInfoMapper = categoryInfoMapper
        self.moneyAmountMapper = moneyAmountMapper
    }

    public func mapFromGSheet(_ rows: [[String]]) async throws -> [BudgetTotals.Entry] {
        try rows.compactMap { row in
            guard row.count >= Column.count else {
//                throw CurrentBudgetEntriesMapperError.invalidRow(row)
                return nil
            }

            let category = try categoryInfoMapper.mapFromGSheet(row[.category])
//            let balance = try moneyAmountMapper.mapFromGSheet(row[.balance])
            let balanceString = row[.balance]

            return BudgetTotals.Entry(
                category: category,
//                balance: balance
                balanceString: balanceString
            )
        }
    }

    private func parseDate(_ dateString: String) throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: dateString) else {
            throw CurrentBudgetEntriesMapperError.invalidDate(dateString)
        }

        return date
    }
}

private extension Array where Element == String {
    subscript(column: CurrentBudgetEntriesMapper.Column) -> String {
        self[column.rawValue]
    }
}
