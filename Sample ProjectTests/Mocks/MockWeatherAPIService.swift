//
//  MockWeatherAPIService.swift
//  Sample ProjectTests
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation
import Combine
@testable import Sample_Project

class MockWeatherAPIService: WeatherAPIService {
    private let shouldFail: Bool
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, Error> {
        if shouldFail {
            return Fail(error: WeatherError.fetchFailed).eraseToAnyPublisher()
        }
        
        let response = WeatherResponse(
            name: "Test City",
            main: .init(temp: 25.0, humidity: 60),
            weather: [.init(description: "Sunny", icon: "01d")],
            wind: .init(speed: 5.0)
        )
        
        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchWeatherDetail(lat: Double, lon: Double) -> AnyPublisher<WeatherDetailResponse, Error> {
        if shouldFail {
            return Fail(error: WeatherError.fetchFailed).eraseToAnyPublisher()
        }
        
        let forecastItem = WeatherDetailResponse.ForecastItem(
            dt: Date().timeIntervalSince1970,
            main: .init(temp: 25.0, humidity: 60),
            weather: [.init(description: "Sunny", icon: "01d")],
            wind: .init(speed: 5.0)
        )
        
        let response = WeatherDetailResponse(
            list: Array(repeating: forecastItem, count: 8),
            city: .init(name: "Test City")
        )
        
        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func searchCities(query: String) -> AnyPublisher<[CityResponse], Error> {
        if shouldFail {
            return Fail(error: WeatherError.fetchFailed).eraseToAnyPublisher()
        }
        
        let response = CityResponse(
            name: query,
            lat: 0.0,
            lon: 0.0,
            country: "ID",
            state: "Jakarta"
        )
        
        return Just([response])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
