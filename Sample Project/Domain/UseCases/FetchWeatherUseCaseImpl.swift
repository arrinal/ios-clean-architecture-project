//
//  FetchWeatherUseCaseImpl.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation
import Combine

class FetchWeatherUseCaseImpl: FetchWeatherUseCase {
    private let repository: WeatherRepository
    
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    func execute(lat: Double, lon: Double, cityName: String) -> AnyPublisher<Weather, Error> {
        repository.fetchWeather(lat: lat, lon: lon, cityName: cityName)
    }
    
    func executeDetail(lat: Double, lon: Double, cityName: String) -> AnyPublisher<WeatherDetail, Error> {
        repository.fetchWeatherDetail(lat: lat, lon: lon, cityName: cityName)
    }
}
