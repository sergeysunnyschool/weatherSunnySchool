//
//  UserDefaults+Extension.swift
//  Weather
//
//  Created by Local Express on 01.04.21.
//

import Foundation

extension UserDefaults {
    
    static var cities: [City]? {
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "cities")
            UserDefaults.standard.synchronize()
        }
        get {
            if let storesData = UserDefaults.standard.object(forKey: "cities") as? Data {
                return try? PropertyListDecoder().decode([City].self, from: storesData)
            }
            return nil
        }
    }
}
