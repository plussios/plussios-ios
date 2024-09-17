//
//  SettingsViewModel.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

import Factory

import PlussiosCore

final class SettingsViewModel: ObservableObject {
    @Injected(\.userSettingsStorage)
    private var settingsStorage: SecureUserSettingsStorageProtocol

    @Injected(\.watchConnector)
    private var watchConnector: WatchConnectorProtocol

    func loadSheetsURL() async throws -> String? {
        try await loadSheetsId()?.shareableLink
    }

    func loadSheetsId() async throws -> GSheetId? {
        guard let settings = try await settingsStorage.load() else {
            return nil
        }

        watchConnector.sendToWatch(sheetId: settings.sheetId)

        return settings.sheetId
    }

    func set(googleSheetsURL: String) async throws {
        var settings = try await settingsStorage.load() ?? SecureUserSettings()

        let sheetId: GSheetId
        do {
            sheetId = try GSheetId(sheetURL: googleSheetsURL)
            settings.sheetId = sheetId
        } catch {
            throw error
        }

        try await settingsStorage.save(settings)

        watchConnector.sendToWatch(sheetId: sheetId)
    }
}
