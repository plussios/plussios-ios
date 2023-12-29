//
//  CategoryInfo.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public struct CategoryInfo: CustomStringConvertible, Codable {
    public typealias Id = String

    public let id: Id
    public let name: String

    public init(id: Id, name: String) {
        self.id = id
        self.name = name
    }

    public var description: String {
        return "\(name) (\(id))"
    }
}

extension CategoryInfo: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

