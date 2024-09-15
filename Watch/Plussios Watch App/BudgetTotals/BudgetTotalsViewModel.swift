//
//  BudgetTotalsViewModel.swift
//  Plussios
//
//  Created by Stan Sidel on 9/14/24.
//

import SwiftUI

import Factory

import PlussiosCore

enum BudgetTotalsState {
    case empty
    case loading
    case data(BudgetTotals)
    case error(Error)
}

final class BudgetTotalsViewModel: ObservableObject {

    @Published var state: BudgetTotalsState = .empty

    func loadData() {
        Task {
            do {
                let totals = try await budgetRepository.loadCurrentBudget()
                await set(state: .data(totals))
            } catch {
                await set(state: .error(error))
            }
        }
    }

    // MARK: - Private

    @Injected(\.budgetRepository) private var budgetRepository: BudgetRepositoryProtocol

    @MainActor
    private func set(state: BudgetTotalsState) async {
        self.state = state
    }
}
