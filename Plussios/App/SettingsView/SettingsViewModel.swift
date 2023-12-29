//
//  SettingsViewModel.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation
import PlussiosCore

final class SettingsViewModel: ObservableObject {
    private let settingsStorage: SecureUserSettingsStorageProtocol

    init(settingsStorage: SecureUserSettingsStorageProtocol) {
        self.settingsStorage = settingsStorage
    }

    func loadSheetsURL() async throws -> String? {
        try await loadSheetsId()?.shareableLink
    }

    func loadSheetsId() async throws -> GSheetId? {
        guard let settings = try await settingsStorage.load() else {
            return nil
        }

        return settings.sheetId
    }

    func set(googleSheetsURL: String) async throws {
        var settings = try await settingsStorage.load() ?? SecureUserSettings()

        do {
            let id = try GSheetId(sheetURL: googleSheetsURL)
            settings.sheetId = id
        } catch {
            throw error
        }

        try await settingsStorage.save(settings)
    }
}
