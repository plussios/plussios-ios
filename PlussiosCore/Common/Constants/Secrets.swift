//
//  Secrets.swift
//  PlussiosCore
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public final class Secrets {
    // Shared instance
    public static let shared = Secrets()
    private init() {}

    // FIXME: Use env var to get this value
    public let gSheetsApiKey = ""

    public let sentryDsn = "https://080dae8b56c8c9bddf71a451884137e0@o1027320.ingest.sentry.io/4506506161881088"
}
