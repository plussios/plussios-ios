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

    public init(date: Date, entries: [Entry]) {
        self.date = date
        self.entries = entries
    }

    public struct Entry: CustomStringConvertible, Decodable, Identifiable {
        public let id = UUID()

        public let category: CategoryInfo
//        let balance: MoneyAmount
        // Load the string before we add a complication of parsing the actual amount from the string
        public let balanceString: String

        enum CodingKeys: CodingKey {
            case category
            case balanceString
        }

        public init(category: CategoryInfo, balanceString: String) {
            self.category = category
            self.balanceString = balanceString
        }

        public var description: String {
            "\(category)\t\(balanceString)"
        }
    }
}
