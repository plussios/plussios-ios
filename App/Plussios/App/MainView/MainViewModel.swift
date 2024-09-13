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

    private let budgetRepository: BudgetRepositoryProtocol
    private let expenseTotalsRepository: ExpenseTotalsRepositoryProtocol

    init(
        budgetRepository: BudgetRepositoryProtocol,
        expenseTotalsRepository: ExpenseTotalsRepositoryProtocol
    ) {
        self.budgetRepository = budgetRepository
        self.expenseTotalsRepository = expenseTotalsRepository
    }

    func loadData() {
        Task {
            do {
                let budget = try await budgetRepository.loadCurrentBudget()
                let totals = try await expenseTotalsRepository.loadCurrentExpenses(period: .day)
                state = .data(MainViewData(budget: budget, totals: totals))
            } catch {
                state = .error(error)
            }
        }
    }
}
