//
//  KeychainManager.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-03.
//

import Foundation

class KeychainManager {
    static func save(key: String, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    static func load(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else {
            return nil
        }
    }
    
    static func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    static func saveString(_ string: String, forKey key: String) -> Bool {
        if let data = string.data(using: .utf8) {
            return save(key: key, data: data)
        }
        return false
    }
    
    static func loadString(forKey key: String) -> String? {
        if let data = load(key: key) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    static func saveBool(_ value: Bool, forKey key: String) -> Bool {
        let intValue = value ? 1 : 0
        if let data = String(intValue).data(using: .utf8) {
            return save(key: key, data: data)
        }
        return false
    }
    
    static func loadBool(forKey key: String) -> Bool? {
        if let string = loadString(forKey: key),
           let intValue = Int(string) {
            return intValue == 1
        }
        return nil
    }
}
