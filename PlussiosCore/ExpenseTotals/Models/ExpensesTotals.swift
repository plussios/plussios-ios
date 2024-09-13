//
//  ExpensesTotals.swift
//  PlussiosCore
//
//  Created by Stan Sidel on 02.01.2024.
//

import Foundation

public struct ExpensesTotals: Decodable {
    public struct Entry: Decodable {
        public let category: CategoryInfo
        public let amountString: String

        public init(category: CategoryInfo, amountString: String) {
            self.category = category
            self.amountString = amountString
        }
    }

    public let date: Date
    public let period: ExpensesPeriod
    public let entries: [Entry]

    public init(date: Date, period: ExpensesPeriod, entries: [Entry]) {
        self.date = date
        self.period = period
        self.entries = entries
    }
}
