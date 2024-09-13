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
    case missingSheetId
}

struct CurrentBudgetResponse: Decodable {
    let rows: [BudgetTotals.Entry]
}

struct CurrentExpensesResponse: Decodable {
    let period: ExpensesPeriod
    let rows: [ExpensesTotals.Entry]
}

public final class PlussiosApiClient {
    private enum Constants {
        static let host = "https://api.plussios.com"
    }

    private let sessionDelegate = SessionDelegate()
    private let userSettingsStorage: SecureUserSettingsStorageProtocol

    public init(userSettingsStorage: SecureUserSettingsStorageProtocol) {
        self.userSettingsStorage = userSettingsStorage
    }

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

    public func loadCurrentExpenses(sheetId: GSheetId, period: ExpensesPeriod) async throws -> ExpensesTotals {
        // Make an HTTP request to https://api.plussios.com/expenses/current with sheetId and period as a query parameter
        guard let endpoint = URL(string: "\(Constants.host)/expenses/current?spreadsheetId=\(sheetId.sheetId)&period=\(period.rawValue)") else {
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

        // Try to decode the data into a `ExpensesTotals` object
        let parsedResponse = try JSONDecoder().decode(CurrentExpensesResponse.self, from: data)

        let expensesTotals = ExpensesTotals(
            date: Date(),
            period: parsedResponse.period,
            entries: parsedResponse.rows
        )

        return expensesTotals
    }

    private func getSheetId() async throws -> GSheetId {
        guard let settings = try await userSettingsStorage.load(),
              let sheetId = settings.sheetId
        else {
            throw PlussiosApiClientError.missingSheetId
        }

        return sheetId
    }
}

extension PlussiosApiClient: ExpenseTotalsRepositoryProtocol {

    public func loadCurrentExpenses(period: ExpensesPeriod) async throws -> ExpensesTotals {
        let sheetId = try await getSheetId()
        return try await loadCurrentExpenses(sheetId: sheetId, period: period)
    }
}

extension PlussiosApiClient: BudgetRepositoryProtocol {

    public func loadCurrentBudget() async throws -> BudgetTotals {
        let sheetId = try await getSheetId()
        return try await loadCurrentBudget(sheetId: sheetId)
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
