//
//  WeatherAPIServiceTests.swift
//  Sample ProjectTests
//
//  Created by Arrinal S on 14/12/24.
//

import Testing
import Foundation
import Combine
@testable import Sample_Project

@Suite("WeatherAPIService Tests")
struct WeatherAPIServiceTests {
    
    @Test("Successfully fetch weather")
    func testFetchWeather() async throws {
        let service = MockWeatherAPIService()
        
        let weather = try await service.fetchWeather(lat: 0, lon: 0).async()
        
        #expect(weather.name == "Test City")
        #expect(weather.main.temp == 25.0)
        #expect(weather.main.humidity == 60)
        #expect(weather.weather[0].description == "Sunny")
        #expect(weather.weather[0].icon == "01d")
        #expect(weather.wind.speed == 5.0)
    }
    
    @Test("Failed to fetch weather")
    func testFetchWeatherFailed() async throws {
        let service = MockWeatherAPIService(shouldFail: true)
        
        await #expect(throws: WeatherError.fetchFailed) {
            _ = try await service.fetchWeather(lat: 0, lon: 0).async()
        }
    }
    
    @Test("Successfully fetch weather detail")
    func testFetchWeatherDetail() async throws {
        let service = MockWeatherAPIService()
        
        let detail = try await service.fetchWeatherDetail(lat: 0, lon: 0).async()
        
        #expect(detail.city.name == "Test City")
        #expect(detail.list.count == 8)
        #expect(detail.list[0].main.temp == 25.0)
        #expect(detail.list[0].main.humidity == 60)
        #expect(detail.list[0].weather[0].description == "Sunny")
        #expect(detail.list[0].weather[0].icon == "01d")
        #expect(detail.list[0].wind.speed == 5.0)
    }
    
    @Test("Failed to fetch weather detail")
    func testFetchWeatherDetailFailed() async throws {
        let service = MockWeatherAPIService(shouldFail: true)
        
        await #expect(throws: WeatherError.fetchFailed) {
            _ = try await service.fetchWeatherDetail(lat: 0, lon: 0).async()
        }
    }
    
    @Test("Successfully search cities")
    func testSearchCities() async throws {
        let service = MockWeatherAPIService()
        
        let cities = try await service.searchCities(query: "Test").async()
        
        #expect(!cities.isEmpty)
        #expect(cities[0].name == "Test")
        #expect(cities[0].country == "ID")
        #expect(cities[0].state == "Jakarta")
    }
    
    @Test("Failed to search cities")
    func testSearchCitiesFailed() async throws {
        let service = MockWeatherAPIService(shouldFail: true)
        
        await #expect(throws: WeatherError.fetchFailed) {
            _ = try await service.searchCities(query: "Test").async()
        }
    }
}
