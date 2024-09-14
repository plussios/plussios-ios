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
    @StateObject private var appModel = PlussiosAppModel(
        settingsStorage: SecureUserSettingsStorageFactory.shared.make()
    )

    init() {
        SentrySDK.start { options in
            options.dsn = Secrets.shared.sentryDsn
            options.debug = false
            options.tracesSampleRate = 1

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
            case .welcome, .main:
                SettingsView(
                    viewModel: SettingsViewModel(
                        settingsStorage: SecureUserSettingsStorageFactory.shared.make()
                    )
                )
//            case .main:
//                MainView(
//                    viewModel: MainViewModel(
//                        budgetRepository: BudgetRepositoryFactory.shared.make(),
//                        expenseTotalsRepository: ExpenseTotalsRepositoryFactory.shared.make()
//                    )
//                )
            case .error(let error):
                Text(error?.localizedDescription ?? "Unknown error")
            }
        }
    }
}
