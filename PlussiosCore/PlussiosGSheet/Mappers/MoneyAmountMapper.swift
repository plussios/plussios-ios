//
//  MoneyAmountMapper.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public protocol MoneyAmountMapperProtocol {
    func mapFromGSheet(_ amount: String) throws -> MoneyAmount
}

public struct MoneyAmountMapper: MoneyAmountMapperProtocol {
    public init() {}

    public func mapFromGSheet(_ amount: String) throws -> MoneyAmount {
        guard let amount = Double(amount) else {
            throw MapperError.invalidAmount(amount)
        }
        
        return MoneyAmount(human: amount, currency: nil)
    }
}
