//
//  UserDefaultsManager.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-03.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}
    
    private let defaults = UserDefaults.standard

    private enum Keys: String {
        case isOnboardTourDone
        case userPreferences
        case loggedInUserId
    }
    
    var isOnboardTourDone: Bool {
        get { defaults.bool(forKey: Keys.isOnboardTourDone.rawValue) }
        set { defaults.set(newValue, forKey: Keys.isOnboardTourDone.rawValue) }
    }
    
    var loggedInUserId: String? {
        get { defaults.string(forKey: Keys.loggedInUserId.rawValue) }
        set { defaults.set(newValue, forKey: Keys.loggedInUserId.rawValue) }
    }

    struct UserPreferences: Codable {
        let prefersDarkMode: Bool
        let languageCode: String
    }

    var userPreferences: UserPreferences? {
        get {
            guard let data = defaults.data(forKey: Keys.userPreferences.rawValue) else { return nil }
            return try? JSONDecoder().decode(UserPreferences.self, from: data)
        }
        set {
            if let newValue = newValue {
                if let encoded = try? JSONEncoder().encode(newValue) {
                    defaults.set(encoded, forKey: Keys.userPreferences.rawValue)
                }
            } else {
                defaults.removeObject(forKey: Keys.userPreferences.rawValue)
            }
        }
    }
    
    func removeAll() {
        for key in [Keys.isOnboardTourDone, Keys.userPreferences] {
            defaults.removeObject(forKey: key.rawValue)
        }
    }
}
