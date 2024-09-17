//
//  WatchConnector.swift
//  Plussios
//
//  Created by Stan Sidel on 9/16/24.
//

import WatchConnectivity

import Factory

import PlussiosCore

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject {
    
    @Injected(\.watchSettings)
    private var watchSettings: WatchSettings

    static let shared = WatchConnector()

    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    // MARK: - WCSessionDelegate

    // Receive the message from the iOS app
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        setSheetId(from: message)
    }

    // Handle the asynchronous data transfer when the iPhone becomes reachable
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        setSheetId(from: userInfo)
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        print("Session")
    }

    // MARK: - Private Functions

    private func setSheetId(from dict: [String: Any]) {
        if let sheetId = dict["sheetId"] as? String {
            let gSheetId = !sheetId.isEmpty ? GSheetId(sheetId: sheetId) : nil
            Task {
                await self.watchSettings.save(sheetId: gSheetId)
            }
        }
    }
}
