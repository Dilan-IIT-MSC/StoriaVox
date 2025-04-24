//
//  DictionaryExtesions.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-04.
//

import Foundation

extension Dictionary {
    func valueForKeyPath <T> (_ keyPath: String) -> T? {
        let array = keyPath.components(separatedBy: ".")
        return value(array, self) as? T
        
    }
    
    func valueForKey <T> (_ key: String) -> T? {
        return valueForKeyPath(key)
    }
    
    func dateValueForKey(_ key: String) -> Date? {
        if let dateText: String = valueForKey(key) {
            let newFormatter = ISO8601DateFormatter()
            return newFormatter.date(from: dateText)
        } else {
            return nil
        }
    }

    private func value(_ keys: [String], _ dictionary: Any?) -> Any? {
        guard let dictionary = dictionary as? [String: Any], !keys.isEmpty else {
            return nil
        }
        if keys.count == 1 {
            return dictionary[keys[0]]
        }
        return value(Array(keys.suffix(keys.count - 1)), dictionary[keys[0]])
    }
}
