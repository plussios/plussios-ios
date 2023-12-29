//
//  CategoryInfoMapper.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public protocol CategoryInfoMapperProtocol {
    func mapFromGSheet(_ category: String) throws -> CategoryInfo
}

public final class CategoryInfoMapper: CategoryInfoMapperProtocol {
    public init() {}

    public func mapFromGSheet(_ category: String) throws -> CategoryInfo {
        CategoryInfo(id: category, name: category)
    }
}
