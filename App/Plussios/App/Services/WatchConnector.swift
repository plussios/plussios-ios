//
//  WatchConnector.swift
//  Plussios
//
//  Created by Stan Sidel on 9/15/24.
//


import WatchConnectivity

import PlussiosCore

protocol WatchConnectorProtocol {
    func sendToWatch(sheetId: GSheetId?)
}

final class WatchConnector: NSObject, WCSessionDelegate, WatchConnectorProtocol {

    static let shared = WatchConnector()

    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func sendToWatch(sheetId: GSheetId?) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["sheetId": sheetId?.sheetId ?? ""], replyHandler: nil, errorHandler: { error in
                print("Error sending URL to Watch: \(error)")
            })
        } else {
            WCSession.default.transferUserInfo(["sheetId": sheetId?.sheetId ?? ""])
        }
    }
    
    // WCSessionDelegate methods

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        print(#function)
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print(#function)
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print(#function)
    }
}
