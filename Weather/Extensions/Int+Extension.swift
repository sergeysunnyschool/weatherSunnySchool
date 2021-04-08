//
//  Int+Extension.swift
//  Weather
//
//  Created by Local Express on 08.04.21.
//

import Foundation

extension Int {
    
    var toInervaleSince1970Date: Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
    
}
