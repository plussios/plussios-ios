//
//  PlussiosWidgetBundle.swift
//  PlussiosWidget
//
//  Created by Stan Sidel on 29.12.2023.
//

import WidgetKit
import SwiftUI
import Sentry
import PlussiosCore

@main
struct PlussiosWidgetBundle: WidgetBundle {
    init() {
        SentrySDK.start { options in
            options.dsn = Secrets.shared.sentryDsn
            options.debug = true // Enabled debug when first installing is always helpful
            options.enableTracing = true

            // Uncomment the following lines to add more data to your events
            // options.attachScreenshot = true // This adds a screenshot to the error events
            // options.attachViewHierarchy = true // This adds the view hierarchy to the error events
        }
    }

    var body: some Widget {
//        PlussiosWidget()
        CurrentBudgetWidget()
        CurrentExpensesWidget()
        PlussiosWidgetLiveActivity()
    }
}
