//
//  MockFetchWeatherRepository.swift
//  Sample ProjectTests
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation
import Combine
@testable import Sample_Project

class MockFetchWeatherRepository: FetchWeatherRepository {
    private let shouldFail: Bool
    private let delay: TimeInterval
    
    init(shouldFail: Bool = false, delay: TimeInterval = 0) {
        self.shouldFail = shouldFail
        self.delay = delay
    }
    
    func fetchWeather(lat: Double, lon: Double, cityName: String) -> AnyPublisher<Weather, Error> {
        if shouldFail {
            return Fail(error: WeatherError.fetchFailed)
                .delay(for: .seconds(delay), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        return Just(Weather.mock(cityName: cityName))
            .setFailureType(to: Error.self)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func fetchWeatherDetail(lat: Double, lon: Double, cityName: String) -> AnyPublisher<WeatherDetail, Error> {
        if shouldFail {
            return Fail(error: WeatherError.fetchFailed)
                .delay(for: .seconds(delay), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        return Just(WeatherDetail.mock(cityName: cityName))
            .setFailureType(to: Error.self)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func searchCities(query: String) -> AnyPublisher<[CityResponse], Error> {
        if shouldFail {
            return Fail(error: WeatherError.fetchFailed)
                .delay(for: .seconds(delay), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        return Just([CityResponse.mock(query: query)])
            .setFailureType(to: Error.self)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
