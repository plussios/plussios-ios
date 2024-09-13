//
//  CurrentBudgetWidgetIntent.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import WidgetKit
import AppIntents

struct CurrentBudgetWidgetIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Current budget configuration"
    static var description = IntentDescription("Widget with current budget balance.")

    @Parameter(title: "page", default: 1)
    var page: Int

    @MainActor func perform() async throws -> some IntentResult {
        print("action")
        return .result()
    }
}
