//
//  BudgetTotalsView.swift
//  Plussios
//
//  Created by Stan Sidel on 9/14/24.
//

import SwiftUI

import Factory

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
                Text("Date: \(totals.date.ISO8601Format())")
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

#Preview {
    BudgetTotalsView()
}
