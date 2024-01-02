//
//  PlussiosWidgetBundle.swift
//  PlussiosWidget
//
//  Created by Stan Sidel on 29.12.2023.
//

import WidgetKit
import SwiftUI

@main
struct PlussiosWidgetBundle: WidgetBundle {
    var body: some Widget {
//        PlussiosWidget()
        CurrentBudgetWidget()
        PlussiosWidgetLiveActivity()
    }
}
