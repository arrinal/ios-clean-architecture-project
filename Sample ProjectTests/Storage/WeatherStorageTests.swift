//
//  WeatherStorageTests.swift
//  Sample ProjectTests
//
//  Created by Arrinal S on 14/12/24.
//

import Testing
import Foundation
@testable import Sample_Project

@Suite("WeatherStorage Tests")
struct WeatherStorageTests {
    
    @Test("Successfully save cities")
    func testSaveCities() async throws {
        let storage = MockWeatherStorage()
        let cities = [Weather.mock()]
        
        try await storage.saveCities(cities).async()
        let loadedCities = try await storage.loadCities().async()
        
        #expect(loadedCities.count == 1)
        #expect(loadedCities[0].cityName == "Test City")
    }
    
    @Test("Failed to save cities")
    func testSaveCitiesFailed() async throws {
        let storage = MockWeatherStorage(shouldFail: true)
        let cities = [Weather.mock()]
        
        await #expect(throws: StorageError.saveFailed) {
            _ = try await storage.saveCities(cities).async()
        }
    }
    
    @Test("Successfully load cities")
    func testLoadCities() async throws {
        let storage = MockWeatherStorage()
        let cities = [Weather.mock()]
        
        try await storage.saveCities(cities).async()
        let loadedCities = try await storage.loadCities().async()
        
        #expect(loadedCities.count == 1)
        #expect(loadedCities[0].cityName == "Test City")
        #expect(loadedCities[0].temperature == 25.0)
        #expect(loadedCities[0].description == "Sunny")
    }
    
    @Test("Failed to load cities")
    func testLoadCitiesFailed() async throws {
        let storage = MockWeatherStorage(shouldFail: true)
        
        await #expect(throws: StorageError.loadFailed) {
            _ = try await storage.loadCities().async()
        }
    }
}
