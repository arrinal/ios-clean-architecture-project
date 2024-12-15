//
//  MockOpenWeatherMapService.swift
//  Sample ProjectTests
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation
import Combine
@testable import Sample_Project

class MockOpenWeatherMapService: OpenWeatherMapService {
    private let shouldFail: Bool
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, Error> {
        if shouldFail {
            return Fail(error: WeatherError.fetchFailed).eraseToAnyPublisher()
        }
        
        let response = WeatherResponse(
            coord: .init(lon: lon, lat: lat),
            weather: [.init(id: 800, main: "Clear", description: "Sunny", icon: "01d")],
            base: "stations",
            main: .init(temp: 25.0, feelsLike: 26.0, tempMin: 24.0, tempMax: 26.0, pressure: 1013, humidity: 60, seaLevel: nil, groundLevel: nil),
            visibility: 10000,
            wind: .init(speed: 5.0, deg: 120, gust: nil),
            clouds: .init(all: 0),
            dt: Int(Date().timeIntervalSince1970),
            sys: .init(sunrise: Int(Date().timeIntervalSince1970), sunset: Int(Date().timeIntervalSince1970 + 43200)),
            timezone: 25200,
            id: 123456,
            name: "Test City"
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
            main: WeatherResponse.MainWeather(
                temp: 25.0,
                feelsLike: 26.0,
                tempMin: 24.0,
                tempMax: 26.0,
                pressure: 1013,
                humidity: 60,
                seaLevel: nil,
                groundLevel: nil
            ),
            weather: [
                WeatherResponse.WeatherDescription(
                    id: 800,
                    main: "Clear",
                    description: "Sunny",
                    icon: "01d"
                )
            ],
            wind: WeatherResponse.Wind(
                speed: 5.0,
                deg: 120,
                gust: nil
            )
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
