//
//  MoneyAmount.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public struct Currency {
    public let code: String
    public let symbol: String

    public init(code: String, symbol: String) {
        self.code = code
        self.symbol = symbol
    }
}

public struct MoneyAmount {
    public let amount: Int
    public let currency: Currency?

    public init(amount: Int, currency: Currency?) {
        self.amount = amount
        self.currency = currency
    }

    public init(human: Double, currency: Currency?) {
        self.amount = Int(human * 100)
        self.currency = currency
    }

    public var human: Double {
        Double(amount) / 100
    }
}
