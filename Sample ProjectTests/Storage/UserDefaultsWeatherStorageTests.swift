//
//  UserDefaultsWeatherStorageTests.swift
//  Sample ProjectTests
//
//  Created by Arrinal S on 14/12/24.
//

import Testing
import Foundation
import Combine
@testable import Sample_Project

@Suite("UserDefaultsWeatherStorage Tests")
struct UserDefaultsWeatherStorageTests {
    
    func setUp() {
        // Clean up any existing data before each test
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
    
    @Test("Successfully save and load cities")
    func testSaveAndLoadCities() async throws {
        setUp()
        let storage = UserDefaultsWeatherStorageImpl()
        let cities = [Weather.mock()]
        
        try await storage.saveCities(cities).async()
        let loadedCities = try await storage.loadCities().async()
        
        #expect(loadedCities.count == 1)
        #expect(loadedCities[0].cityName == "Test City")
        #expect(loadedCities[0].temperature == 25.0)
    }
    
    @Test("Load empty cities when no data saved")
    func testLoadEmptyCities() async throws {
        setUp()
        let storage = UserDefaultsWeatherStorageImpl()
        
        let loadedCities = try await storage.loadCities().async()
        
        #expect(loadedCities.isEmpty)
    }
}
