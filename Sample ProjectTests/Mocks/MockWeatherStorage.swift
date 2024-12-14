//
//  MockWeatherStorage.swift
//  Sample ProjectTests
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation
import Combine
@testable import Sample_Project
import Sample_Project // Add this line to import StorageError

class MockWeatherStorage: WeatherStorage {
    private var cities: [Weather] = []
    private let shouldFail: Bool
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func saveCities(_ cities: [Weather]) -> AnyPublisher<Void, Error> {
        if shouldFail {
            return Fail(error: StorageError.saveFailed).eraseToAnyPublisher()
        }
        self.cities = cities
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func loadCities() -> AnyPublisher<[Weather], Error> {
        if shouldFail {
            return Fail(error: StorageError.loadFailed).eraseToAnyPublisher()
        }
        return Just(cities).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
