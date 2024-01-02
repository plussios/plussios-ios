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

    func placeholder(in context: Context) -> CurrentBudgetEntry {
        CurrentBudgetEntry(date: Date(), configuration: CurrentBudgetWidgetIntent(), totals: .success([]))
    }

    func snapshot(for configuration: CurrentBudgetWidgetIntent, in context: Context) async -> CurrentBudgetEntry {
        CurrentBudgetEntry(date: Date(), configuration: configuration, totals: .success([]))
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
        let maxEntries: Int

        switch context.family {
        case .systemSmall:
            maxEntries = 3
        case .systemMedium:
            maxEntries = 5
        case .systemLarge:
            maxEntries = 12
        case .systemExtraLarge:
            maxEntries = 12
        case .accessoryCircular:
            maxEntries = 3
        case .accessoryRectangular:
            maxEntries = 3
        case .accessoryInline:
            maxEntries = 1
        @unknown default:
            maxEntries = 3
        }

        let page = max(1, configuration.page)

        return Array(entries.suffix(from: maxEntries * (page - 1)).prefix(maxEntries))
    }
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
