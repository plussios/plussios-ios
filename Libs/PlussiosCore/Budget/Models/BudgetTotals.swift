//
//  BudgetTotals.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public struct BudgetTotals {
    public let date: Date
    public let entries: [Entry]

    public struct Entry: CustomStringConvertible, Decodable {
        public let category: CategoryInfo
//        let balance: MoneyAmount
        // Load the string before we add a complication of parsing the actual amount from the string
        public let balanceString: String

        public init(category: CategoryInfo, balanceString: String) {
            self.category = category
            self.balanceString = balanceString
        }

        public var description: String {
            "\(category)\t\(balanceString)"
        }
    }
}
