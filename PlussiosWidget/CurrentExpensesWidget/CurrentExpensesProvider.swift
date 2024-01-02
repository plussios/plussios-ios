//
//  CurrentBudgetProvider.swift
//  PlussiosWidgetExtension
//
//  Created by Stan Sidel on 02.01.2024.
//

import Foundation

import WidgetKit
import SwiftUI

import PlussiosCore

enum CurrentExpensesProviderError: Error {
    case missingSheetId

    var localizedDescription: String {
        switch self {
        case .missingSheetId:
            return "Missing sheet ID"
        }
    }
}

struct CurrentExpensesProvider: AppIntentTimelineProvider {
    private let settingsStorage: SecureUserSettingsStorageProtocol
    private let plussiosClient: PlussiosClientProtocol

    init(settingsStorage: SecureUserSettingsStorageProtocol, plussiosClient: PlussiosClientProtocol) {
        self.settingsStorage = settingsStorage
        self.plussiosClient = plussiosClient
    }

    // A generic representation of the widget while loading
    func placeholder(in context: Context) -> CurrentExpensesEntry {
        CurrentExpensesEntry(date: Date(), configuration: CurrentExpensesWidgetIntent(), totals: .success(ExpensesTotals(date: Date(), period: .month, entries: [])))
    }

    // A snapshot in widget gallery or while in transition
    func snapshot(for configuration: CurrentExpensesWidgetIntent, in context: Context) async -> CurrentExpensesEntry {
        if context.isPreview {
            // Appearance in the Widget Gallery
            CurrentExpensesEntry(
                date: Date(),
                configuration: configuration,
                totals: .success(
                    ExpensesTotals(
                        date: Date(),
                        period: configuration.period.expensesPeriod,
                        entries: Array(sampleExpensesEntries.prefix(getMaxEntries(for: context.family)))
                    )
                )
            )
        } else {
            // Appearance in transition
            CurrentExpensesEntry(date: Date(), configuration: configuration, totals: .success(ExpensesTotals(date: Date(), period: configuration.period.expensesPeriod, entries: [])))
        }
    }

    func timeline(for configuration: CurrentExpensesWidgetIntent, in context: Context) async -> Timeline<CurrentExpensesEntry> {
        var entries: [CurrentExpensesEntry] = []

        let period = configuration.period.expensesPeriod
        let entry: CurrentExpensesEntry
        do {
            let userSettings = try await settingsStorage.load()
            guard let sheetId = userSettings?.sheetId else {
                throw CurrentExpensesProviderError.missingSheetId
            }

            let totals = try await plussiosClient.loadCurrentExpenses(sheetId: sheetId, period: period)
            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: totals.date)!
            entry = CurrentExpensesEntry(
                date: nextUpdateDate,
                configuration: configuration,
                totals: .success(prepare(totals: totals, for: context, configuration: configuration))
            )
        } catch {
            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
            entry = CurrentExpensesEntry(
                date: nextUpdateDate,
                configuration: configuration,
                totals: .failure(error)
            )
        }
        entries.append(entry)

        return Timeline(entries: entries, policy: .atEnd)
    }

    private func prepare(
        totals: ExpensesTotals,
        for context: Context,
        configuration: CurrentExpensesWidgetIntent
    ) -> ExpensesTotals {
        let maxEntries = getMaxEntries(for: context.family)

        let page = max(1, configuration.page)

        return ExpensesTotals(
            date: totals.date,
            period: totals.period,
            entries: Array(totals.entries.suffix(from: maxEntries * (page - 1)).prefix(maxEntries))
            )
    }

    private func getMaxEntries(for family: WidgetFamily) -> Int {
        switch family {
        case .systemSmall:
            return 3
        case .systemMedium:
            return 5
        case .systemLarge:
            return 12
        case .systemExtraLarge:
            return 12
        case .accessoryCircular:
            return 3
        case .accessoryRectangular:
            return 3
        case .accessoryInline:
            return 1
        @unknown default:
            return 3
        }
    }

    private let sampleExpensesEntries: [ExpensesTotals.Entry] = [
        ExpensesTotals.Entry(category: .named("Groceries"), amountString: "$3,120.45"),
        ExpensesTotals.Entry(category: .named("Utilities"), amountString: "$1,250.30"),
        ExpensesTotals.Entry(category: .named("Rent"), amountString: "$2,800.00"),
        ExpensesTotals.Entry(category: .named("Transportation"), amountString: "$900.75"),
        ExpensesTotals.Entry(category: .named("Dining Out"), amountString: "$560.50"),
        ExpensesTotals.Entry(category: .named("Entertainment"), amountString: "$725.60"),
        ExpensesTotals.Entry(category: .named("Healthcare"), amountString: "$1,180.20"),
        ExpensesTotals.Entry(category: .named("Clothing"), amountString: "$400.00"),
        ExpensesTotals.Entry(category: .named("Education"), amountString: "$2,100.00"),
        ExpensesTotals.Entry(category: .named("Savings"), amountString: "$5,000.00"),
        ExpensesTotals.Entry(category: .named("Travel"), amountString: "$3,300.00"),
        ExpensesTotals.Entry(category: .named("Gifts"), amountString: "$650.00"),
        ExpensesTotals.Entry(category: .named("Fitness"), amountString: "$320.00"),
        ExpensesTotals.Entry(category: .named("Insurance"), amountString: "$1,500.00"),
        ExpensesTotals.Entry(category: .named("Electronics"), amountString: "$850.00"),
        ExpensesTotals.Entry(category: .named("Personal Care"), amountString: "$230.00"),
        ExpensesTotals.Entry(category: .named("Pet Care"), amountString: "$280.00"),
        ExpensesTotals.Entry(category: .named("Home Maintenance"), amountString: "$1,125.00"),
        ExpensesTotals.Entry(category: .named("Subscriptions"), amountString: "$120.00"),
        ExpensesTotals.Entry(category: .named("Miscellaneous"), amountString: "$500.00")
    ]
}

// For iOS 16
extension CurrentExpensesProvider: TimelineProvider {

    func getSnapshot(in context: Context, completion: @escaping (CurrentExpensesEntry) -> ()) {
        Task {
            let entry = await snapshot(for: CurrentExpensesWidgetIntent(), in: context)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CurrentExpensesEntry>) -> ()) {
        Task {
            let timeline = await timeline(for: CurrentExpensesWidgetIntent(), in: context)
            completion(timeline)
        }
    }
}

private extension CategoryInfo {
    static func named(_ name: String) -> CategoryInfo {
        CategoryInfo(id: name, name: name)
    }
}
