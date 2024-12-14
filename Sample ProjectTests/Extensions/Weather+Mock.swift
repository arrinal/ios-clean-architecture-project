//
//  Weather+Mock.swift
//  Sample ProjectTests
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation
@testable import Sample_Project

extension Weather {
    static func mock(cityName: String = "Test City") -> Weather {
        Weather(
            cityName: cityName,
            temperature: 25.0,
            description: "Sunny",
            humidity: 60,
            windSpeed: 5.0,
            icon: "01d",
            lat: 0.0,
            lon: 0.0
        )
    }
}

extension WeatherDetail {
    static func mock(cityName: String = "Test City") -> WeatherDetail {
        WeatherDetail(
            currentWeather: .mock(cityName: cityName),
            hourlyForecast: Array(repeating: .mock(cityName: cityName), count: 8),
            dailyForecast: Array(repeating: .mock(cityName: cityName), count: 5)
        )
    }
}

extension CityResponse {
    static func mock(query: String = "Test") -> CityResponse {
        CityResponse(
            name: query,
            lat: 0.0,
            lon: 0.0,
            country: "ID",
            state: "Jakarta"
        )
    }
}
