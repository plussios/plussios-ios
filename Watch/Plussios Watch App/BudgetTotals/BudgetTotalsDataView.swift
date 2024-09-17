//
//  BudgetTotalsDataView.swift
//  Plussios
//
//  Created by Stan Sidel on 9/17/24.
//

import SwiftUI

import PlussiosCore

struct BudgetTotalsDataView: View {
    let totals: BudgetTotals

    var body: some View {
        VStack {
            Text("Budget Totals:")
            List(totals.entries) { entry in
                BudgetTotalsRow(entry: entry)
            }
        }
    }
}

struct BudgetTotalsRow: View {
    let entry: BudgetTotals.Entry

    var body: some View {
        HStack {
            Text(entry.category.name)
            Spacer()
            Text(entry.balanceString)
        }
    }
}

#Preview {
    let totals = BudgetTotals(
        date: Date(),
        entries: mockEntries
    )

    BudgetTotalsDataView(totals: totals)
}

private let mockEntries: [BudgetTotals.Entry] = [
    .simple("Groceries", "$120.12"),
    .simple("Fun", "$1,879.19"),
    .simple("Rent", "$1,000.00"),
    .simple("Utilities & Other Expenses", "$100,001.00"),
    .simple("Gas", "$40.00"),
    .simple("Car", "$300.00"),
    .simple("Misc", "$200.00"),
    .simple("Savings", "$1,000.00"),
    .simple("Investments", "$1,000.00"),
    .simple("Retirement", "$1,000.00"),
    .simple("Travel", "$1,000.00"),
    .simple("Health", "$1,000.00"),
]

private extension BudgetTotals.Entry {
    static func simple(_ categoryName: String, _ amount: String) -> BudgetTotals.Entry {
        BudgetTotals.Entry(
            category: CategoryInfo(id: categoryName, name: categoryName),
            balanceString: amount
        )
    }
}
