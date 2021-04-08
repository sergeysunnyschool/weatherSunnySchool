//
//  City.swift
//  Weather
//
//  Created by Local Express on 01.04.21.
//

import Foundation

class City: Codable {
    var name: String?
    let lat: Double
    let lng: Double
    var weathers: Weathers?
//    var isSelected = false
    
    init(name: String?, lat: Double, lng: Double) {
        self.name = name
        self.lat = lat
        self.lng = lng
    }
    
}
