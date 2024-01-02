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

public enum KeychainError: Error, LocalizedError {
    case unableToRead(errorCode: String)
    case unableToSave(errorCode: String)
    case unableToDelete(errorCode: String)

    public var errorDescription: String? {
        switch self {
        case .unableToRead(let errorCode):
            return "Error reading values. Code: \(errorCode)"
        case .unableToSave(let errorCode):
            return "Error saving values. Code: \(errorCode)"
        case .unableToDelete(let errorCode):
            return "Error deleting values. Code: \(errorCode)"
        }
    }
}

final public class Keychain: KeychainProtocol {
    public init() {}

    public func save(_ data: Data, forKey key: String) async throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
        ] as [CFString : Any]
        
        for attrAccessible in allAttrAccessible {
            var delQuery = query
            delQuery[kSecAttrAccessible] = attrAccessible
            let deleteStatus = SecItemDelete(delQuery as CFDictionary)
            guard deleteStatus == errSecSuccess || deleteStatus == errSecItemNotFound else {
                throw KeychainError.unableToDelete(errorCode: String(deleteStatus))
            }
        }

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unableToSave(errorCode: String(status))
        }
    }

    public func load(_ key: String) async throws -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        if status == errSecSuccess {
            return result as? Data
        }

        if status == errSecItemNotFound {
            return nil
        }

        throw KeychainError.unableToRead(errorCode: String(status))
    }

    public func delete(_ key: String) async throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        SecItemDelete(query)
    }

    // MARK: - Private

    private let allAttrAccessible: [CFString] = [
        kSecAttrAccessibleWhenUnlocked,
        kSecAttrAccessibleAfterFirstUnlock,
        kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
        kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
    ]
}
