//
//  WeatherEndpoint.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation

enum WeatherEndpoint {
    case currentWeather(lat: Double, lon: Double)
    case weatherDetail(lat: Double, lon: Double)
    case searchCities(query: String)
}

extension WeatherEndpoint: Endpoint {
    var path: String {
        switch self {
        case .currentWeather:
            return "/openweathermap.org/current-weather"
        case .weatherDetail:
            return "/openweathermap.org/current-forecast"
        case .searchCities:
            return "/openweathermap.org/search-cities"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .currentWeather, .weatherDetail, .searchCities:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .currentWeather(let lat, let lon):
            return [
                URLQueryItem(name: "lat", value: String(lat)),
                URLQueryItem(name: "lon", value: String(lon))
            ]
            
        case .weatherDetail(let lat, let lon):
            return [
                URLQueryItem(name: "lat", value: String(lat)),
                URLQueryItem(name: "lon", value: String(lon))
            ]
            
        case .searchCities(let query):
            return [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "limit", value: "5")
            ]
        }
    }
}
