//
//  CurrentBudgetWidget.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import PlussiosCore
import DesignSystem
import WidgetKit
import SwiftUI

struct CurrentBudgetWidgetEntryView: View {
    var entry: CurrentBudgetProvider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        VStack {
            switch entry.totals {
            case .failure(let error):
                Text("Error: \(error?.localizedDescription ?? "Unknown error")")
            case .success(let totals):
                ForEach(totals, id: \.category) { totalsEntry in
                    if widgetFamily == .systemSmall {
                        CurrentBudgetTotalsEntryCompactView(totalsEntry: totalsEntry)
                            .padding(.vertical, 0.1)
                    } else {
                        CurrentBudgetTotalsEntryView(totalsEntry: totalsEntry)
                            .padding(.vertical, 0.1)
                    }
                }
            }
        }
        .foregroundStyle(Color.Widget.text)
    }
}

struct CurrentBudgetTotalsEntryView: View {
    var totalsEntry: BudgetTotals.Entry

    var body: some View {
        HStack {
            Text(totalsEntry.category.name)
            Spacer()
            Text(totalsEntry.balanceString)
        }
    }
}

struct CurrentBudgetTotalsEntryCompactView: View {
    var totalsEntry: BudgetTotals.Entry

    var body: some View {
        VStack {
            HStack {
                Text(totalsEntry.category.name)
                Spacer()
            }
            HStack {
                Spacer()
                Text(totalsEntry.balanceString)
            }
        }
    }
}

struct CurrentBudgetWidget: Widget {
    let kind: String = "CurrentBudgetWidget"
    private let budgetRepository: BudgetRepositoryProtocol

    init() {
        let assembly = Assembly.shared

        budgetRepository = assembly.budgetRepository
    }

    var body: some WidgetConfiguration {
        if #available(iOS 17.0, *) {
            return AppIntentConfiguration(
                kind: kind,
                intent: CurrentBudgetWidgetIntent.self,
                provider: CurrentBudgetProvider(
                    budgetRepository: budgetRepository
                )
            ) { entry in
                CurrentBudgetWidgetEntryView(entry: entry)
                    .containerBackground(Color.Widget.background, for: .widget)
            }
        } else {
            // Fallback for iOS 16
            return StaticConfiguration(
                kind: kind,
                provider: CurrentBudgetProvider(
                    budgetRepository: budgetRepository
                )
            ) { entry in
                CurrentBudgetWidgetEntryView(entry: entry)
                    .background(Color.Widget.background)
            }
        }
    }
}

private extension CurrentBudgetWidgetIntent {
    static var firstPage: CurrentBudgetWidgetIntent {
        let intent = CurrentBudgetWidgetIntent()
        intent.page = 1
        return intent
    }

    static var secondPage: CurrentBudgetWidgetIntent {
        let intent = CurrentBudgetWidgetIntent()
        intent.page = 2
        return intent
    }
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

@available(iOS 17.0, *)
#Preview(as: .systemSmall) {
    CurrentBudgetWidget()
} timeline: {
    CurrentBudgetEntry(
        date: .now,
        configuration: .firstPage,
        totals: .success(Array(mockEntries.prefix(3)))
    )
}

@available(iOS 17.0, *)
#Preview(as: .systemMedium) {
    CurrentBudgetWidget()
} timeline: {
    CurrentBudgetEntry(
        date: .now,
        configuration: .firstPage,
        totals: .success(Array(mockEntries.prefix(5)))
    )
}


@available(iOS 17.0, *)
#Preview(as: .systemLarge) {
    CurrentBudgetWidget()
} timeline: {
    CurrentBudgetEntry(
        date: .now,
        configuration: .firstPage,
        totals: .success(Array(mockEntries.prefix(12)))
    )
}

//// Widget Preview
//struct CurrentBudgetWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrentBudgetWidgetEntryView(
//            entry: CurrentBudgetEntry(date: .now, configuration: .firstPage, totals: .success([]))
//        )
//        .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}

private extension BudgetTotals.Entry {
    static func simple(_ categoryName: String, _ amount: String) -> BudgetTotals.Entry {
        BudgetTotals.Entry(
            category: CategoryInfo(id: categoryName, name: categoryName),
            balanceString: amount
        )
    }
}
