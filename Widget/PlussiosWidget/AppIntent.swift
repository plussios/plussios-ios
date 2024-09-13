//
//  AppIntent.swift
//  PlussiosWidget
//
//  Created by Stan Sidel on 29.12.2023.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String

    @MainActor func perform() async throws -> some IntentResult {
        print("action")
        return .result()
    }
}
