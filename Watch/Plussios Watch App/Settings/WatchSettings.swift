//
//  WatchSettings.swift
//  Plussios
//
//  Created by Stan Sidel on 9/17/24.
//

import Factory

import PlussiosCore

final class WatchSettings: ObservableObject {
    @Injected(\.userSettingsStorage)
    private var userSettingsStorage: SecureUserSettingsStorageProtocol

    @Published private(set) var sheetId: GSheetId?

    init() {
        Task {
            await load()
        }
    }

    func load() async {
        do {
            let settings = try await userSettingsStorage.load()
            await MainActor.run { sheetId = settings?.sheetId }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func save(sheetId: GSheetId?) async {
        do {
            var settings = try await userSettingsStorage.load() ?? SecureUserSettings()

            settings.sheetId = sheetId

            try await userSettingsStorage.save(settings)

            await MainActor.run { self.sheetId = sheetId }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
