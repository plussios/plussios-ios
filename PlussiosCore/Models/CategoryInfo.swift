//
//  CategoryInfo.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public struct CategoryInfo: CustomStringConvertible {
    public typealias Id = String

    public let id: Id

    public var name: String { id }

    public init(id: Id) {
        self.id = id
    }

    public var description: String {
        return id
    }
}

extension CategoryInfo: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

