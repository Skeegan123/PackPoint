//
//  UserDefaultsManager.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/28/23.
//

import Foundation

class UserDefaultsManager {
    private let userDefaults = UserDefaults.standard
    private let userIdKey = "userId"

    static let shared = UserDefaultsManager()

    func saveUserId(_ userId: Int) {
        userDefaults.set(userId, forKey: userIdKey)
    }

    func getUserId() -> Int? {
        return userDefaults.integer(forKey: userIdKey)
    }
}
