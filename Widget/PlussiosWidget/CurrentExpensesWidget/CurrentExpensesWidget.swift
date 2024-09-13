//
//  CurrentExpensesWidget.swift
//  Plussios
//
//  Created by Stan Sidel on 02.01.2024.
//

import PlussiosCore
import DesignSystem
import WidgetKit
import SwiftUI

struct CurrentExpensesWidgetEntryView: View {
    var entry: CurrentExpensesProvider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        VStack {
            switch entry.totals {
            case .failure(let error):
                Text("Error: \(error?.localizedDescription ?? "Unknown error")")
            case .success(let totals):
                ForEach(totals.entries, id: \.category) { totalsEntry in
                    if widgetFamily == .systemSmall {
                        CurrentExpensesTotalsEntryCompactView(totalsEntry: totalsEntry, period: totals.period)
                            .padding(.vertical, 0.1)
                    } else {
                        CurrentExpensesTotalsEntryView(totalsEntry: totalsEntry, period: totals.period)
                            .padding(.vertical, 0.1)
                    }
                }
            }
        }
        .foregroundStyle(Color.Widget.text)
    }
}

struct CurrentExpensesTotalsEntryView: View {
    var totalsEntry: ExpensesTotals.Entry
    var period: ExpensesPeriod

    var body: some View {
        HStack {
            Text(totalsEntry.category.name)
            Spacer()
            Text("\(period.shortDisplay): \(totalsEntry.amountString)")
        }
    }
}

struct CurrentExpensesTotalsEntryCompactView: View {
    var totalsEntry: ExpensesTotals.Entry
    var period: ExpensesPeriod

    var body: some View {
        VStack {
            HStack {
                Text(totalsEntry.category.name)
                Spacer()
            }
            HStack {
                Spacer()
                Text("\(period.shortDisplay): \(totalsEntry.amountString)")
            }
        }
    }
}

struct CurrentExpensesWidget: Widget {
    let kind: String = "CurrentExpensesWidget"
    private let settingsStorage: SecureUserSettingsStorageProtocol
    private let expenseTotalsRepository: ExpenseTotalsRepositoryProtocol

    init() {
        let assembly = Assembly.shared

        settingsStorage = assembly.userSettingsStorage
        expenseTotalsRepository = assembly.expenseTotalsRepository
    }

    var body: some WidgetConfiguration {
        if #available(iOS 17.0, *) {
            return AppIntentConfiguration(
                kind: kind,
                intent: CurrentExpensesWidgetIntent.self,
                provider: CurrentExpensesProvider(
                    expenseTotalsRepository: expenseTotalsRepository
                )
            ) { entry in
                CurrentExpensesWidgetEntryView(entry: entry)
                    .containerBackground(Color.Widget.background, for: .widget)
            }
        } else {
            // Fallback for iOS 16
            return StaticConfiguration(
                kind: kind,
                provider: CurrentExpensesProvider(
                    expenseTotalsRepository: expenseTotalsRepository
                )
            ) { entry in
                CurrentExpensesWidgetEntryView(entry: entry)
                    .background(Color.Widget.background)
            }
        }
    }
}

private extension CurrentExpensesWidgetIntent {
    static var firstPage: CurrentExpensesWidgetIntent {
        let intent = CurrentExpensesWidgetIntent()
        intent.page = 1
        return intent
    }

    static var secondPage: CurrentExpensesWidgetIntent {
        let intent = CurrentExpensesWidgetIntent()
        intent.page = 2
        return intent
    }
}

private let mockEntries: [ExpensesTotals.Entry] = [
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
    CurrentExpensesWidget()
} timeline: {
    CurrentExpensesEntry(
        date: .now,
        configuration: .firstPage,
        totals: .success(ExpensesTotals(date: Date(), period: .month, entries: Array(mockEntries.prefix(3))))
    )
}

@available(iOS 17.0, *)
#Preview(as: .systemMedium) {
    CurrentExpensesWidget()
} timeline: {
    CurrentExpensesEntry(
        date: .now,
        configuration: .firstPage,
        totals: .success(ExpensesTotals(date: Date(), period: .month, entries: Array(mockEntries.prefix(5))))
    )
}


@available(iOS 17.0, *)
#Preview(as: .systemLarge) {
    CurrentExpensesWidget()
} timeline: {
    CurrentExpensesEntry(
        date: .now,
        configuration: .firstPage,
        totals: .success(ExpensesTotals(date: Date(), period: .month, entries: Array(mockEntries.prefix(12))))
    )
}

//// Widget Preview
//struct CurrentExpensesWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrentExpensesWidgetEntryView(
//            entry: CurrentExpensesEntry(date: .now, configuration: .firstPage, totals: .success([]))
//        )
//        .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}

private extension ExpensesTotals.Entry {
    static func simple(_ categoryName: String, _ amount: String) -> ExpensesTotals.Entry {
        ExpensesTotals.Entry(
            category: CategoryInfo(id: categoryName, name: categoryName),
            amountString: amount
        )
    }
}

private extension ExpensesPeriod {
    var shortDisplay: String {
        switch self {
        case .day: "D"
        case .week: "W"
        case .month: "M"
        }
    }
}
