//
//  ContentView.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var googleSheetURL = ""

    var body: some View {
        VStack {
            TextField("Google Sheet url", text: $googleSheetURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save") {
                // Handle save action
                saveURL(googleSheetURL)
            }
            .padding()
        }
    }

    private func saveURL(_ url: String) {
        // Save the URL for later use
        // You might want to validate and fetch data from the URL here
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

