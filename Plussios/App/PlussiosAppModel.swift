//
//  PlussiosAppModel.swift
//  Plussios
//
//  Created by Stan Sidel on 08.01.2024.
//

import SwiftUI
import PlussiosCore

final class PlussiosAppModel: ObservableObject {
    enum State {
        case loading
        case welcome
        case main
        case error(Error?)
    }

    @Published var state: State = .loading

    private let settingsStorage: SecureUserSettingsStorageProtocol

    init(settingsStorage: SecureUserSettingsStorageProtocol) {
        self.settingsStorage = settingsStorage
    }

    func load() {
        Task {
            do {
                let settings = try await settingsStorage.load()
                let googleSheetsId = settings?.sheetId
                await MainActor.run {
                    state = googleSheetsId != nil ? .main : .welcome
                }
            } catch {
                await MainActor.run {
                    state = .error(error)
                }
            }
        }
    }
}
