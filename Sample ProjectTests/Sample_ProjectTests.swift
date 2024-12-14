//
//  Sample_ProjectTests.swift
//  Sample ProjectTests
//
//  Created by Arrinal S on 13/12/24.
//

import Testing
import Combine
@testable import Sample_Project

// MARK: - FetchWeatherUseCase Tests
@Test("FetchWeatherUseCase executes successfully")
func testFetchWeatherSuccess() async throws {
    let mockRepository = MockWeatherRepository()
    let useCase = FetchWeatherUseCaseImpl(repository: mockRepository)
    
    let weather = try await useCase.execute(lat: 0, lon: 0, cityName: "Test").async()
    #expect(weather.cityName == "Test")
    #expect(weather.temperature == 25.0)
}

@Test("FetchWeatherUseCase handles error")
func testFetchWeatherError() async throws {
    let mockRepository = MockWeatherRepository(shouldFail: true)
    let useCase = FetchWeatherUseCaseImpl(repository: mockRepository)
    
    await #expect(throws: WeatherError.fetchFailed) {
        _ = try await useCase.execute(lat: 0, lon: 0, cityName: "Test").async()
    }
}

@Test("FetchWeatherUseCase fetches detail successfully")
func testFetchWeatherDetailSuccess() async throws {
    let mockRepository = MockWeatherRepository()
    let useCase = FetchWeatherUseCaseImpl(repository: mockRepository)
    
    let detail = try await useCase.executeDetail(lat: 0, lon: 0, cityName: "Test").async()
    #expect(detail.currentWeather.cityName == "Test")
    #expect(detail.hourlyForecast.count == 8)
}

// MARK: - WeatherStorage Tests
@Test("WeatherStorage saves cities successfully")
func testSaveCities() async throws {
    let storage = MockWeatherStorage()
    let cities = [Weather.mock()]
    
    try await storage.saveCities(cities).async()
    let loadedCities = try await storage.loadCities().async()
    #expect(loadedCities.count == 1)
    #expect(loadedCities[0].cityName == cities[0].cityName)
}

@Test("WeatherStorage handles empty state")
func testLoadEmptyCities() async throws {
    let storage = MockWeatherStorage()
    let cities = try await storage.loadCities().async()
    #expect(cities.isEmpty)
}

private extension CityResponse {
    static func mock() -> CityResponse {
        CityResponse(
            name: "Test City",
            lat: 0,
            lon: 0,
            country: "TC",
            state: "Test State"
        )
    }
}

// MARK: - Error Types
enum WeatherError: Error {
    case fetchFailed
}

// MARK: - Combine Extensions for Testing
extension Publisher {
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = self.sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                },
                receiveValue: { value in
                    continuation.resume(returning: value)
                }
            )
        }
    }
}
