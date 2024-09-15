//
//  BudgetTotalsView.swift
//  Plussios
//
//  Created by Stan Sidel on 9/14/24.
//

import SwiftUI

struct BudgetTotalsView: View {
    @StateObject private var viewModel = BudgetTotalsViewModel()

    var body: some View {
        Text("Hello Budget Totals!")
        switch viewModel.state {
        case .empty:
            Button("Load Data") { viewModel.loadData() }
        case .loading:
            ProgressView()
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
}

#Preview {
    BudgetTotalsView()
}
