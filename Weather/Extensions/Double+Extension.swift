//
//  Double+Extension.swift
//  Weather
//
//  Created by Local Express on 08.04.21.
//

import Foundation

extension Double {
    var toTemperature: String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.locale = Locale.current
        formatter.numberFormatter.maximumFractionDigits = 0
        let measurement = Measurement(value: self, unit: UnitTemperature.fahrenheit)
        return formatter.string(from: measurement)
    }
}
