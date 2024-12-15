//
//  FetchWeatherUseCaseTests.swift
//  Sample ProjectTests
//
//  Created by Arrinal S on 14/12/24.
//

import Testing
import Foundation
import Combine
@testable import Sample_Project

@Suite("FetchWeatherUseCase Tests")
struct FetchWeatherUseCaseTests {
    
    @Test("Successfully fetch weather")
    func testFetchWeather() async throws {
        let repository = MockFetchWeatherRepository()
        let useCase = FetchWeatherUseCaseImpl(repository: repository)
        
        let weather = try await useCase.execute(lat: 0, lon: 0, cityName: "Test").async()
        
        #expect(weather.cityName == "Test")
        #expect(weather.temperature == 25.0)
        #expect(weather.description == "Sunny")
        #expect(weather.humidity == 60)
        #expect(weather.windSpeed == 5.0)
        #expect(weather.icon == "01d")
    }
    
    @Test("Failed to fetch weather")
    func testFetchWeatherFailed() async throws {
        let repository = MockFetchWeatherRepository(shouldFail: true)
        let useCase = FetchWeatherUseCaseImpl(repository: repository)
        
        await #expect(throws: WeatherError.fetchFailed) {
            _ = try await useCase.execute(lat: 0, lon: 0, cityName: "Test").async()
        }
    }
    
    @Test("Successfully fetch weather detail")
    func testFetchWeatherDetail() async throws {
        let repository = MockFetchWeatherRepository()
        let useCase = FetchWeatherUseCaseImpl(repository: repository)
        
        let detail = try await useCase.executeDetail(lat: 0, lon: 0, cityName: "Test").async()
        
        #expect(detail.currentWeather.cityName == "Test")
        #expect(detail.hourlyForecast.count == 8)
        #expect(detail.dailyForecast.count == 5)
    }
    
    @Test("Failed to fetch weather detail")
    func testFetchWeatherDetailFailed() async throws {
        let repository = MockFetchWeatherRepository(shouldFail: true)
        let useCase = FetchWeatherUseCaseImpl(repository: repository)
        
        await #expect(throws: WeatherError.fetchFailed) {
            _ = try await useCase.executeDetail(lat: 0, lon: 0, cityName: "Test").async()
        }
    }
}
