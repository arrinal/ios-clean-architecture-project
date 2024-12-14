//
//  WeatherStorage.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation
import Combine

protocol WeatherStorage {
    func saveCities(_ cities: [Weather]) -> AnyPublisher<Void, Error>
    func loadCities() -> AnyPublisher<[Weather], Error>
}
