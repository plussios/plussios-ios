//
//  SettingsView.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import SwiftUI

import Factory

import PlussiosCore

struct SettingsView: View {
    let viewModel: SettingsViewModel
    @State private var googleSheetURL = ""
    @State private var isSavingSheetURL = false
    @State private var isSettingsLoaded = false
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            TextField("Google Sheet url", text: $googleSheetURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(!isSettingsLoaded || isSavingSheetURL)
                .padding()

            Button("Save") {
                // Handle save action
                saveURL(googleSheetURL)
            }
            .disabled(isSavingSheetURL)
            .padding()
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .padding()
            }
            Button("Test") {
                loadBudget()
            }
            .disabled(!isSettingsLoaded)
            .padding()
        }
        .onAppear {
            reloadSheetsURL()
        }
    }

    private func saveURL(_ url: String) {
        isSavingSheetURL = true
        Task {
            do {
                try await viewModel.set(googleSheetsURL: url)
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                }
            }

            await MainActor.run {
                isSavingSheetURL = false
            }
        }
    }

    private func loadBudget() {
        // FIXME: Remove this
        Task {
            let sheetId: GSheetId?
            do {
                sheetId = try await viewModel.loadSheetsId()
            } catch {
                return
            }
            guard let sheetId else { return }

            let client = PlussiosApiClient(
                userSettingsStorage: Container.shared.userSettingsStorage()
            )

            do {
                let budget = try await client.loadCurrentBudget(sheetId: sheetId)
                print(budget)
            } catch {
                print(error)
            }
        }
    }

    private func reloadSheetsURL() {
        Task {
            let url: String?
            do {
                url = try await viewModel.loadSheetsURL()
            } catch {
                // TODO: Log the error
                return
            }
            await MainActor.run {
                googleSheetURL = url ?? ""
                isSettingsLoaded = true
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}

private final class SecureUserSettingsStorageMock: SecureUserSettingsStorageProtocol {
    func save(_ userSettings: SecureUserSettings) async throws {
    }
    
    func load() async throws -> SecureUserSettings? {
        nil
    }
}

