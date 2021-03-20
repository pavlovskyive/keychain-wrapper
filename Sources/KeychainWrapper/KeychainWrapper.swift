//
//  KeychainWrapperError.swift
//
//
//  Created by Vsevolod Pavlovskyi on 20.03.2021.
//

import Foundation

public final class KeychainWrapper {

    public func set(_ value: String, forKey service: String) throws {

        if value.isEmpty {
            try delete(forKey: service)
            return
        }

        guard let valueData = value.data(using: .utf8) else {
            print("Error converting value to data.")
            throw KeychainWrapperError(type: .badData)
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecValueData as String: valueData
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        switch status {
        case errSecSuccess:
            break
        case errSecDuplicateItem:
            try update(value, forKey: service)
        default:
            throw KeychainWrapperError(status: status, type: .servicesError)
        }
    }

    public func get(forKey service: String) throws -> String {

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,

            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,

            kSecReturnData as String: true
        ]

        var item: CFTypeRef?

        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            throw KeychainWrapperError(type: .itemNotFound)
        }

        guard status == errSecSuccess else {
            throw KeychainWrapperError(status: status, type: .servicesError)
        }

        guard let existingItem = item as? [String: Any],
              let valueData = existingItem[kSecValueData as String] as? Data,
              let value = String(data: valueData, encoding: .utf8)
        else {
            throw KeychainWrapperError(type: .unableToConvertToString)
        }

        return value
    }

    public func update(_ value: String, forKey service: String) throws {

        guard let valueData = value.data(using: .utf8) else {
            throw KeychainWrapperError(type: .unableToConvertToData)
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: valueData
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else {
            throw KeychainWrapperError(message: "Matching Item Not Found", type: .itemNotFound)
        }

        guard status == errSecSuccess else {
            throw KeychainWrapperError(status: status, type: .servicesError)
        }
    }

    public func delete(forKey service: String) throws {

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainWrapperError(status: status, type: .servicesError)
        }
    }

}
