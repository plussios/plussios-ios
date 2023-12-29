//
//  SheetFullRange.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public struct SheetFullRange {
    public let sheetName: String?
    public let range: String?

    public init(sheetName: String, range: String? = nil) {
        self.sheetName = sheetName
        self.range = range
    }

    public init(range: String) {
        self.sheetName = nil
        self.range = range
    }

    public var rangeForRequest: String {
        var result = ""

        if let sheetName {
            result = "\(sheetName)"
            if range != nil {
                result += "!"
            }
        }
        if let range {
            result += range
        }

        // TODO: Log if result is empty
        return result
    }
}
