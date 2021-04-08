//
//  Network.swift
//  Weather
//
//  Created by Local Express on 03.04.21.
//

import Foundation
import Alamofire

final class Network {
    
    static let shared = Network()
    
    private init() { }
    
    //Reachibility
    
    func getCurrentWaether(cityName: String, unit: TemperatureUnit, completion: @escaping (Any?, Error?) -> ()) {
        if let originString = "http://api.openweathermap.org/data/2.5/weather?q=\(cityName)&units=\(unit.rawValue)&appid=\(OpenWeather.key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: originString) {
            AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    completion(json, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func getWaether(cityName: String, unit: TemperatureUnit, completion: @escaping (Any?, Error?) -> ()) {
        http://api.openweathermap.org/data/2.5/forecast?q=London,us&mode=xml&appid=158f3eb880d189487baaff784e0202c9
        if let originString = "http://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&units=\(unit.rawValue)&appid=\(OpenWeather.key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: originString) {
            AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    completion(json, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
}
//http://api.openweathermap.org/data/2.5/weather?q=Yerevan&appid=158f3eb880d189487baaff784e0202c9
//http://api.openweathermap.org/data/2.5/weather?q=Yerevan&appid=158f3eb880d189487baaff784e0202c9
