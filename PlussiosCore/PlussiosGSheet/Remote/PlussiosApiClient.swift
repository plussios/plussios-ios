//
//  PlussiosApiClient.swift
//  PlussiosCore
//
//  Created by Stan Sidel on 30.12.2023.
//

import Foundation

public enum PlussiosApiClientError: Error {
    case invalidEndpoint
    case statusCodeNotOK
}

struct CurrentBudgetResponse: Decodable {
    let rows: [BudgetTotals.Entry]
}

public final class PlussiosApiClient: PlussiosClientProtocol {
    private enum Constants {
        static let host = "https://api.plussios.com"
    }

    private let sessionDelegate = SessionDelegate()

    public init() {}

    public func loadCurrentBudget(sheetId: GSheetId) async throws -> BudgetTotals {
        // Make an HTTP request to https://api.plussios.com/budget/current with sheetId as a query parameter
        guard let endpoint = URL(string: "\(Constants.host)/budget/current?spreadsheetId=\(sheetId.sheetId)") else {
            throw PlussiosApiClientError.invalidEndpoint
        }

        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration, delegate: sessionDelegate, delegateQueue: .main)

        // Create a URLSessionDataTask with our URL
        let (data, response) = try await session.data(from: endpoint)

        // Check if the status code is 200 (OK)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PlussiosApiClientError.statusCodeNotOK
        }

        // Try to decode the data into a `BudgetTotals` object
        let parsedResponse = try JSONDecoder().decode(CurrentBudgetResponse.self, from: data)

        let budgetTotals = BudgetTotals(
            date: Date(),
            entries: parsedResponse.rows
        )

        return budgetTotals
    }
}

private class SessionDelegate: NSObject, URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        // Accept any certificate for local.plussios.dev
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           challenge.protectionSpace.host == "local.plussios.dev"
        {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            return (.useCredential, credential)
        }
        return (.performDefaultHandling, nil)
    }
}
