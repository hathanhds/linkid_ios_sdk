//
//  AppUserDefaults.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 19/06/2024.
//

import Foundation

struct AppUserDefaults {
    static func valueForKey(_ key: AppUserDefaultKey) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    static func setValue(_ value: Any?, forKey key: AppUserDefaultKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func removeValue(_ key: AppUserDefaultKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}

enum AppUserDefaultKey: String {
    case lynkIDUserPoint
}

extension AppUserDefaults {
    static var userPoint: Double {
        get {
            if let userPoint = AppUserDefaults.valueForKey(.lynkIDUserPoint) as? Double {
                return userPoint
            } else {
                return 0
            }
        } set {
            AppUserDefaults.setValue(newValue, forKey: .lynkIDUserPoint)
        }
    }

}
