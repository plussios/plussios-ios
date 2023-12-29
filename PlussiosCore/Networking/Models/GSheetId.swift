//
//  GSheetId.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public enum GSheetIdError: Error {
    case invalidURL
}

public struct GSheetId: Codable {
    public let sheetId: String

    public init(sheetId: String) {
        self.sheetId = sheetId
    }

    public init(sheetURL: String) throws {
        // Extract sheet id from a sharable Google Sheets URL
        // https://docs.google.com/spreadsheets/d/<sheetId>/edit#gid=0
        let regex = try NSRegularExpression(pattern: "https://docs.google.com/spreadsheets/d/([^/]*)(/.*)?")
        let range = NSRange(sheetURL.startIndex..<sheetURL.endIndex, in: sheetURL)

        guard let match = regex.firstMatch(in: sheetURL, options: [], range: range) else {
            throw GSheetIdError.invalidURL
        }

        guard let sheetIdRange = Range(match.range(at: 1), in: sheetURL) else {
            throw GSheetIdError.invalidURL
        }

        self.sheetId = String(sheetURL[sheetIdRange])
    }

    public var shareableLink: String {
        "https://docs.google.com/spreadsheets/d/\(sheetId)"
    }
}
