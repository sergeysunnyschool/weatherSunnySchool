//
//  Weather.swift
//  Weather
//
//  Created by Local Express on 03.04.21.
//

import Foundation

class Weathers: Codable {
//    var temp: Double?
    var temp: [Temp] = []
    var sunrise: Int?
    var sunset: Int?
    var timezone: Int?
    
    init(_ json: Any) {
        if let dict = json as? Dictionary<String, Any> {
            if let list = dict["list"] as? Array<Dictionary<String, Any>> {
                self.temp = list.map({Temp($0)})
                dump(temp)
            }
            if let sys = dict["city"] as? Dictionary<String, Any> {
                self.sunrise = sys["sunrise"] as? Int
                self.sunset = sys["sunset"] as? Int
            }
        }
    }
    
}

class Temp: Codable {
    var dt: Int?
    var value: Double?
    
    init(_ json: Dictionary<String, Any>) {
        if let date = json["dt"] as? Int {
            self.dt = date
        }
        if let main = json["main"] as? Dictionary<String, Any> {
            if let temp = main["temp"] as? Int {
                self.value = Double(temp)
            } else if let temp = main["temp"] as? Double {
                self.value = temp
            }
        }
    }
    
}


class Weather: Codable {
    var temp: Double?
    var sunrise: Int?
    var sunset: Int?
    var timezone: Int?
    
    init(_ json: Any) {
        if let dict = json as? Dictionary<String, Any> {
            if let main = dict["main"] as? Dictionary<String, Any> {
                if let temp = main["temp"] as? Int {
                    self.temp = Double(temp)
                } else if let temp = main["temp"] as? Double {
                    self.temp = temp
                }
                
            }
            if let sys = dict["sys"] as? Dictionary<String, Any> {
                self.sunrise = sys["sunrise"] as? Int
                self.sunset = sys["sunset"] as? Int
            }
            self.timezone = dict["timezone"] as? Int
        }
    }
    
}
