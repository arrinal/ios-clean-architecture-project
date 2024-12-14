//
//  WeatherResponse.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: MainWeather
    let weather: [WeatherDescription]
    let wind: Wind
    
    struct MainWeather: Codable {
        let temp: Double
        let humidity: Int
    }
    
    struct WeatherDescription: Codable {
        let description: String
        let icon: String
    }
    
    struct Wind: Codable {
        let speed: Double
    }
}

struct WeatherDetailResponse: Codable {
    let list: [ForecastItem]
    let city: City
    
    struct ForecastItem: Codable {
        let dt: TimeInterval
        let main: WeatherResponse.MainWeather
        let weather: [WeatherResponse.WeatherDescription]
        let wind: WeatherResponse.Wind
    }
    
    struct City: Codable {
        let name: String
    }
}
