//
//  PlussiosApp.swift
//  Plussios Watch App
//
//  Created by Stan Sidel on 9/14/24.
//

import SwiftUI

@main
struct Plussios_Watch_AppApp: App {
    private let watchConnector = WatchConnector.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
