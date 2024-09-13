//
//  MainViewModel.swift
//  Plussios
//
//  Created by Stan Sidel on 08.01.2024.
//

import Foundation
import PlussiosCore

struct MainViewData {
    let budget: BudgetTotals
    let totals: ExpensesTotals
}

final class MainViewModel: ObservableObject {
    enum State {
        case loading
        case data(MainViewData)
        case error(Error?)
    }

    @Published var state: State = .loading

    var googleSheetsId: GSheetId
    private let plussiosClient: PlussiosClientProtocol

    init(googleSheetsId: GSheetId, plussiosClient: PlussiosClientProtocol) {
        self.googleSheetsId = googleSheetsId
        self.plussiosClient = plussiosClient
    }

    func loadData() {
        Task {
            do {
                let budget = try await plussiosClient.loadCurrentBudget(sheetId: googleSheetsId)
                let totals = try await plussiosClient.loadCurrentExpenses(sheetId: googleSheetsId, period: .day)
                state = .data(MainViewData(budget: budget, totals: totals))
            } catch {
                state = .error(error)
            }
        }
    }
}
