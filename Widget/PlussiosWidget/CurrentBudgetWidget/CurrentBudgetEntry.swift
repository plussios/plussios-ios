//
//  CurrentBudgetEntry.swift
//  PlussiosWidgetExtension
//
//  Created by Stan Sidel on 29.12.2023.
//

import WidgetKit
import PlussiosCore

struct CurrentBudgetEntry: TimelineEntry {
    enum State {
        case success([BudgetTotals.Entry])
        case failure(Error?)
    }

    let date: Date
    let configuration: CurrentBudgetWidgetIntent
    let totals: State
}
