//
//  PlussiosApp.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import SwiftUI
import Sentry
import PlussiosCore


@main
struct PlussiosApp: App {
    @State private var appModel = PlussiosAppModel(
        settingsStorage: SecureUserSettingsStorageFactory.shared.make()
    )

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

    var body: some Scene {
        WindowGroup {
            switch appModel.state {
            case .loading:
                ProgressView()
                    .onAppear {
                        appModel.load()
                    }
            case .welcome:
                SettingsView(
                    viewModel: SettingsViewModel(
                        settingsStorage: SecureUserSettingsStorageFactory.shared.make()
                    )
                )
            case .main(let sheetsId):
                MainView(
                    viewModel: MainViewModel(
                        googleSheetsId: sheetsId,
                        plussiosClient: PlussiosClientFactory.shared.makeClient()
                    )
                )
            case .error(let error):
                Text(error?.localizedDescription ?? "Unknown error")
            }
        }
    }
}
