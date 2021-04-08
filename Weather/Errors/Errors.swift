//
//  Errors.swift
//  Weather
//
//  Created by Local Express on 03.04.21.
//

import Foundation

enum Errors: Error {
    case errorWeatherForCity(cityName: String, errorDescription: String)
    
    
}

extension Errors: CustomStringConvertible {
    var description: String {
        switch self {
        case .errorWeatherForCity(cityName: let name, errorDescription: let desc):
            return "Issue temperatur for city \(name) \(desc)"
        }
    }
}
