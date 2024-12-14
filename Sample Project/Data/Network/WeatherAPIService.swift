//
//  WeatherAPIService.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation
import Combine

protocol WeatherAPIService {
    func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, Error>
    func fetchWeatherDetail(lat: Double, lon: Double) -> AnyPublisher<WeatherDetailResponse, Error>
    func searchCities(query: String) -> AnyPublisher<[CityResponse], Error>
}

class WeatherAPIServiceImpl: BaseService, WeatherAPIService {
    func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, Error> {
        request(WeatherEndpoint.currentWeather(lat: lat, lon: lon))
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func fetchWeatherDetail(lat: Double, lon: Double) -> AnyPublisher<WeatherDetailResponse, Error> {
        request(WeatherEndpoint.weatherDetail(lat: lat, lon: lon))
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func searchCities(query: String) -> AnyPublisher<[CityResponse], Error> {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        return request(WeatherEndpoint.searchCities(query: encodedQuery))
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
