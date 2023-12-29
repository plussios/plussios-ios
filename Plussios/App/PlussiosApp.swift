//
//  PlussiosApp.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import SwiftUI

@main
struct PlussiosApp: App {
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
