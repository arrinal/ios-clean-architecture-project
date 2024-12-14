//
//  WeatherResponse.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation

struct WeatherResponse: Codable {
    let coord: Coordinate
    let weather: [WeatherDescription]
    let base: String
    let main: MainWeather
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    
    struct Coordinate: Codable {
        let lon: Double
        let lat: Double
    }
    
    struct WeatherDescription: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct MainWeather: Codable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
        let seaLevel: Int?
        let groundLevel: Int?
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case humidity
            case seaLevel = "sea_level"
            case groundLevel = "grnd_level"
        }
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int
        let gust: Double?
    }
    
    struct Clouds: Codable {
        let all: Int
    }
    
    struct Sys: Codable {
        let sunrise: Int
        let sunset: Int
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
