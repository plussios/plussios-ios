//
//  PlussiosApp.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import SwiftUI
import Sentry


@main
struct PlussiosApp: App {
    init() {
        SentrySDK.start { options in
            options.dsn = "https://080dae8b56c8c9bddf71a451884137e0@o1027320.ingest.sentry.io/4506506161881088"
            options.debug = true // Enabled debug when first installing is always helpful
            options.enableTracing = true 

            // Uncomment the following lines to add more data to your events
            // options.attachScreenshot = true // This adds a screenshot to the error events
            // options.attachViewHierarchy = true // This adds the view hierarchy to the error events
        }
    }
    var body: some Scene {
        WindowGroup {
            SettingsView(
                viewModel: SettingsViewModel(
                    settingsStorage: SecureUserSettingsStorageFactory.shared.make()
                )
            )
        }
    }
}
