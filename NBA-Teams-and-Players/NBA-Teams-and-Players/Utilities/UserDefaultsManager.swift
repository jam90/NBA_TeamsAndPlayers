//
//  UserDefaultsManager.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    enum UserDefaultsKeys {
        ///Boolean
        case skipOnBoarding
        
        var path: String {
            switch self {
            case .skipOnBoarding:
                return "skipOnBoarding"
            }
        }
    }
    
    func setValue(_ value: Any, for key: UserDefaultsKeys) {
        let keyString = key.path
        UserDefaults.standard.set(value, forKey: keyString)
        UserDefaults.standard.synchronize()
    }
    
    func removeValue(for key: UserDefaultsKeys) {
        let keyString = key.path
        UserDefaults.standard.removeObject(forKey: keyString)
        UserDefaults.standard.synchronize()
    }
    
    func getValue(for key: UserDefaultsKeys) -> Any? {
        let keyString = key.path
        return UserDefaults.standard.value(forKey: keyString)
    }
    
    func resetAll() {
        let dict = UserDefaults.standard.dictionaryRepresentation()
        for (key, _) in dict {
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
}
