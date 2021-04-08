//
//  CityService.swift
//  Weather
//
//  Created by Local Express on 01.04.21.
//

import Foundation

struct CityService {
    
    func loadCities() -> [City] {
        return UserDefaults.cities ?? []
    }
    
    func saveCity(_ city: City) {
        var cities = loadCities()
        if !cities.contains(where: {$0.name == city.name}) {
            cities.append(city)
            UserDefaults.cities = cities
        }
    }
     
    func deleteCity(_ city: City) {
        var cities = loadCities()
        if let index = cities.firstIndex(where: {$0.name == city.name}) {
            cities.remove(at: index)
            UserDefaults.cities = cities
        }
    }
    
}
