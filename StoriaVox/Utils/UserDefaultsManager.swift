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
        case loggedInUserEmail
        case loggedInUser
        case savedCategories
    }
    
    var isOnboardTourDone: Bool {
        get { defaults.bool(forKey: Keys.isOnboardTourDone.rawValue) }
        set { defaults.set(newValue, forKey: Keys.isOnboardTourDone.rawValue) }
    }
    
    var loggedInUserEmail: String? {
        get { defaults.string(forKey: Keys.loggedInUserEmail.rawValue) }
        set { defaults.set(newValue, forKey: Keys.loggedInUserEmail.rawValue) }
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
    
    var savedCategories: [Category]? {
        get {
            guard let data = defaults.data(forKey: Keys.savedCategories.rawValue) else { return nil }
            return try? JSONDecoder().decode([Category].self, from: data)
        }
        set {
            if let newValue = newValue {
                if let encoded = try? JSONEncoder().encode(newValue) {
                    defaults.set(encoded, forKey: Keys.savedCategories.rawValue)
                }
            } else {
                defaults.removeObject(forKey: Keys.savedCategories.rawValue)
            }
        }
    }
    
    var loggedInUser: User? {
        get {
            guard let data = defaults.data(forKey: Keys.loggedInUser.rawValue) else { return nil }
            return try? JSONDecoder().decode(User.self, from: data)
        }
        set {
            if let newValue = newValue {
                if let encoded = try? JSONEncoder().encode(newValue) {
                    defaults.set(encoded, forKey: Keys.loggedInUser.rawValue)
                }
            } else {
                defaults.removeObject(forKey: Keys.loggedInUser.rawValue)
            }
        }
    }
    
    func removeAll() {
        for key in [Keys.isOnboardTourDone, Keys.userPreferences, Keys.loggedInUserEmail, Keys.savedCategories] {
            defaults.removeObject(forKey: key.rawValue)
        }
    }
}
