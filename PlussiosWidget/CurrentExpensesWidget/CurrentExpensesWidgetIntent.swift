//
//  CurrentBudgetWidgetIntent.swift
//  Plussios
//
//  Created by Stan Sidel on 02.01.2024.
//

import WidgetKit
import AppIntents
import PlussiosCore

struct CurrentExpensesWidgetIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Current expenses configuration"
    static var description = IntentDescription("Widget with current expenses amounts.")

    @Parameter(title: "Page", default: 1)
    var page: Int
    @Parameter(title: "Period", default: ExpensesWidgetPeriod.month)
    var period: ExpensesWidgetPeriod

    @MainActor func perform() async throws -> some IntentResult {
        print("action")
        return .result()
    }
}


enum ExpensesWidgetPeriod: String, AppEnum {
    case day
    case week
    case month

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Period")
    }

    static var caseDisplayRepresentations: [ExpensesWidgetPeriod : DisplayRepresentation] {
        [
            .day: "Day",
            .week: "Week",
            .month: "Month"
        ]
    }

    var expensesPeriod: ExpensesPeriod {
        switch self {
        case .day: return .day
        case .week: return .week
        case .month: return .month
        }
    }
}


