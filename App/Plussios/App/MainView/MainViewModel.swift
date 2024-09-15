//
//  MainViewModel.swift
//  Plussios
//
//  Created by Stan Sidel on 08.01.2024.
//

import Foundation

import Factory

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

    @Injected(\.budgetRepository)
    private var budgetRepository: BudgetRepositoryProtocol

    @Injected(\.expenseTotalsRepository)
    private var expenseTotalsRepository: ExpenseTotalsRepositoryProtocol


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
