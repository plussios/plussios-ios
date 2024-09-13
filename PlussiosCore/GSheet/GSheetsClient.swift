//
//  GSheetsClient.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public protocol GSheetsClientProtocol {
    func fetchSheetData(_ sheetId: GSheetId, _ range: SheetFullRange) async throws -> [[String]]
}

public struct GSheetsResponse: Codable {
    public let range: String
    public let majorDimension: String?
    public let values: [[String]]
}

public final class GSheetsClient: GSheetsClientProtocol {
    private let apiKey: String
    private let session: URLSession
    
    public init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    public func fetchSheetData(_ sheetId: GSheetId, _ range: SheetFullRange) async throws -> [[String]] {
        let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(sheetId.sheetId)/values/"
                      + "\(range.rangeForRequest)?alt=json&key=\(apiKey)")!
        let (data, _) = try await session.data(from: url)
        let response = try JSONDecoder().decode(GSheetsResponse.self, from: data)
        return response.values
    }
}
