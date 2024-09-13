//
//  PlussiosClientFactory.swift
//  Plussios
//
//  Created by Stan Sidel on 08.01.2024.
//

import PlussiosCore

final class PlussiosClientFactory {
    // Shared instance
    static let shared = PlussiosClientFactory()

    func makeClient() -> PlussiosClientProtocol {
        let client = PlussiosApiClient()
        return client
    }
}
