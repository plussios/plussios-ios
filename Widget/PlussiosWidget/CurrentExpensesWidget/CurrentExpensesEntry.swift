//
//  CurrentBudgetEntry.swift
//  PlussiosWidgetExtension
//
//  Created by Stan Sidel on 02.01.2024.
//

import WidgetKit
import PlussiosCore

struct CurrentExpensesEntry: TimelineEntry {
    enum State {
        case success(ExpensesTotals)
        case failure(Error?)
    }

    let date: Date
    let configuration: CurrentExpensesWidgetIntent
    let totals: State
}
