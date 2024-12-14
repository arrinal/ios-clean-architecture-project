//
//  Weather.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation

struct Weather: Identifiable, Codable {
    let id: UUID = UUID()
    let cityName: String
    let temperature: Double
    let description: String
    let humidity: Int
    let windSpeed: Double
    let icon: String
    let lat: Double
    let lon: Double
}

struct WeatherDetail {
    let currentWeather: Weather
    let hourlyForecast: [Weather]
    let dailyForecast: [Weather]
}
