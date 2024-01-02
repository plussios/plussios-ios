//
//  CurrentBudgetProvider.swift
//  PlussiosWidgetExtension
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

import WidgetKit
import SwiftUI

import PlussiosCore

enum CurrentBudgetProviderError: Error {
    case missingSheetId

    var localizedDescription: String {
        switch self {
        case .missingSheetId:
            return "Missing sheet ID"
        }
    }
}

struct CurrentBudgetProvider: AppIntentTimelineProvider {
    private let settingsStorage: SecureUserSettingsStorageProtocol
    private let plussiosClient: PlussiosClientProtocol

    init(settingsStorage: SecureUserSettingsStorageProtocol, plussiosClient: PlussiosClientProtocol) {
        self.settingsStorage = settingsStorage
        self.plussiosClient = plussiosClient
    }

    // A generic representation of the widget while loading
    func placeholder(in context: Context) -> CurrentBudgetEntry {
        CurrentBudgetEntry(date: Date(), configuration: CurrentBudgetWidgetIntent(), totals: .success([]))
    }

    // A snapshot in widget gallery or while in transition
    func snapshot(for configuration: CurrentBudgetWidgetIntent, in context: Context) async -> CurrentBudgetEntry {
        if context.isPreview {
            // Appearance in the Widget Gallery
            CurrentBudgetEntry(
                date: Date(),
                configuration: configuration,
                totals: .success(
                    Array(sampleBudgetEntries.prefix(getMaxEntries(for: context.family)))
                )
            )
        } else {
            // Appearance in transition
            CurrentBudgetEntry(date: Date(), configuration: configuration, totals: .success([]))
        }
    }

    func timeline(for configuration: CurrentBudgetWidgetIntent, in context: Context) async -> Timeline<CurrentBudgetEntry> {
        var entries: [CurrentBudgetEntry] = []

        let entry: CurrentBudgetEntry
        do {
            let userSettings = try await settingsStorage.load()
            guard let sheetId = userSettings?.sheetId else {
                throw CurrentBudgetProviderError.missingSheetId
            }

            let totals = try await plussiosClient.loadCurrentBudget(sheetId: sheetId)
            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: totals.date)!
            entry = CurrentBudgetEntry(
                date: nextUpdateDate,
                configuration: configuration,
                totals: .success(prepare(entries: totals.entries, for: context, configuration: configuration))
            )
        } catch {
            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
            entry = CurrentBudgetEntry(
                date: nextUpdateDate,
                configuration: configuration,
                totals: .failure(error)
            )
        }
        entries.append(entry)

        return Timeline(entries: entries, policy: .atEnd)
    }

    private func prepare(
        entries: [BudgetTotals.Entry],
        for context: Context,
        configuration: CurrentBudgetWidgetIntent
    ) -> [BudgetTotals.Entry] {
        let maxEntries = getMaxEntries(for: context.family)

        let page = max(1, configuration.page)

        return Array(entries.suffix(from: maxEntries * (page - 1)).prefix(maxEntries))
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

    private let sampleBudgetEntries: [BudgetTotals.Entry] = [
        BudgetTotals.Entry(category: .named("Groceries"), balanceString: "$3,120.45"),
        BudgetTotals.Entry(category: .named("Utilities"), balanceString: "$1,250.30"),
        BudgetTotals.Entry(category: .named("Rent"), balanceString: "$2,800.00"),
        BudgetTotals.Entry(category: .named("Transportation"), balanceString: "$900.75"),
        BudgetTotals.Entry(category: .named("Dining Out"), balanceString: "$560.50"),
        BudgetTotals.Entry(category: .named("Entertainment"), balanceString: "$725.60"),
        BudgetTotals.Entry(category: .named("Healthcare"), balanceString: "$1,180.20"),
        BudgetTotals.Entry(category: .named("Clothing"), balanceString: "$400.00"),
        BudgetTotals.Entry(category: .named("Education"), balanceString: "$2,100.00"),
        BudgetTotals.Entry(category: .named("Savings"), balanceString: "$5,000.00"),
        BudgetTotals.Entry(category: .named("Travel"), balanceString: "$3,300.00"),
        BudgetTotals.Entry(category: .named("Gifts"), balanceString: "$650.00"),
        BudgetTotals.Entry(category: .named("Fitness"), balanceString: "$320.00"),
        BudgetTotals.Entry(category: .named("Insurance"), balanceString: "$1,500.00"),
        BudgetTotals.Entry(category: .named("Electronics"), balanceString: "$850.00"),
        BudgetTotals.Entry(category: .named("Personal Care"), balanceString: "$230.00"),
        BudgetTotals.Entry(category: .named("Pet Care"), balanceString: "$280.00"),
        BudgetTotals.Entry(category: .named("Home Maintenance"), balanceString: "$1,125.00"),
        BudgetTotals.Entry(category: .named("Subscriptions"), balanceString: "$120.00"),
        BudgetTotals.Entry(category: .named("Miscellaneous"), balanceString: "$500.00")
    ]
}

// For iOS 16
extension CurrentBudgetProvider: TimelineProvider {

    func getSnapshot(in context: Context, completion: @escaping (CurrentBudgetEntry) -> ()) {
        Task {
            let entry = await snapshot(for: CurrentBudgetWidgetIntent(), in: context)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CurrentBudgetEntry>) -> ()) {
        Task {
            let timeline = await timeline(for: CurrentBudgetWidgetIntent(), in: context)
            completion(timeline)
        }
    }
}

private extension CategoryInfo {
    static func named(_ name: String) -> CategoryInfo {
        CategoryInfo(id: name, name: name)
    }
}
