//
//  Date+Extension.swift
//  Weather
//
//  Created by Local Express on 06.04.21.
//

import Foundation

extension Date {
    func toString(format: String = "HH:mm E") -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
