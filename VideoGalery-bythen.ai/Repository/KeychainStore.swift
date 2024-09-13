//
//  KeychainStore.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/13/24.
//

import Foundation

enum KeychainStoreError: Error {
    case failedToSave
}

protocol SecureStoreProtocol {
    subscript(key: String) -> String? { get set }
}

struct KeychainStore: SecureStoreProtocol {
    subscript(key: String) -> String? {
        get {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecReturnData as String: true,
                kSecMatchLimit as String: kSecMatchLimitOne,
            ]
            
            var result: AnyObject?
            guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
                  let data = result as? Data,
                  let value = String(data: data, encoding: .utf8)
            else { return nil }
            
            return value
        }
        set {
            guard let data = newValue?.data(using: .utf8)
            else { return }
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            
            SecItemDelete(query as CFDictionary)
            SecItemAdd(query as CFDictionary, nil)
        }
    }
}
