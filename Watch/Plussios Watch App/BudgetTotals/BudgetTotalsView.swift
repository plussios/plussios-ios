//
//  BudgetTotalsView.swift
//  Plussios
//
//  Created by Stan Sidel on 9/14/24.
//

import SwiftUI

import Factory

import PlussiosCore

struct BudgetTotalsView: View {
    @StateObject private var viewModel = BudgetTotalsViewModel()

    @InjectedObject(\.watchSettings)
    private var watchSettings: WatchSettings

    var body: some View {
        VStack {
            switch viewModel.state {
            case .empty:
                Button("Load Data") { viewModel.loadData() }
            case .loading:
                ProgressView()
            case .missingSheetId:
                Text("Set your G.Sheet URL in the iOS App")
            case .data(let totals):
                BudgetTotalsDataView(totals: totals)
            case .error(let error):
                VStack {
                    Text("Error:")
                    Text(error.localizedDescription)
                    Button("Retry") { viewModel.loadData() }
                }
            }
        }
        .onChange(of: watchSettings.sheetId) {
            viewModel.loadData()
        }
    }
}


private final class MockBudgetRepository: BudgetRepositoryProtocol {
    var mockTotals: BudgetTotals = BudgetTotals(date: Date(), entries: [])

    func loadCurrentBudget() async throws -> BudgetTotals {
        mockTotals
    }
}

private final class MockUserSettingsStorage: SecureUserSettingsStorageProtocol {
    var mockSettings: SecureUserSettings?
    var latestSavedSettings: SecureUserSettings?

    func save(_ userSettings: SecureUserSettings) async throws {
        latestSavedSettings = userSettings
    }
    
    func load() async throws -> SecureUserSettings? {
        mockSettings
    }
}

#Preview {
    let budgetRepository = MockBudgetRepository()
    let userSettingsStorage = MockUserSettingsStorage()
    let _ = Container.shared.budgetRepository.register { budgetRepository }
    let _ = Container.shared.userSettingsStorage.register { userSettingsStorage }

    // Set a non-nil sheetId in the user settings and register a new WatchSettings to trigger
    // `onChange` event for `watchSettings.sheetId`.
    userSettingsStorage.mockSettings = SecureUserSettings(sheetId: GSheetId(sheetId: "123"))
    let _ = Container.shared.watchSettings.register { WatchSettings() }

    return BudgetTotalsView()
}
