//
//  Keychain.swift
//  Plussios
//
//  Created by Stan Sidel on 29.12.2023.
//

import Foundation

public protocol KeychainProtocol {
    func save(_ data: Data, forKey key: String) async throws
    func load(_ key: String) async throws -> Data?
    func delete(_ key: String) async throws
}

final public class Keychain: KeychainProtocol {
    public init() {}

    public func save(_ data: Data, forKey key: String) async throws {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: key,
                     kSecValueData: data] as CFDictionary

        SecItemDelete(query)
        SecItemAdd(query, nil)
    }

    public func load(_ key: String) async throws -> Data? {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: key,
                     kSecReturnData: true] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        if status == errSecSuccess {
            return result as? Data
        }

        return nil
    }

    public func delete(_ key: String) async throws {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: key] as CFDictionary

        SecItemDelete(query)
    }
}
