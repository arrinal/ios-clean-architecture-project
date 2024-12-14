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

class WeatherAPIServiceImpl: WeatherAPIService {
    private let weatherBaseURL = "https://api.openweathermap.org/data/2.5"
    private let geoBaseURL = "https://api.openweathermap.org/geo/1.0"
    private let apiKey = "d8f0fbba1d25bb2c195c9680a4dbc57d" // Replace with actual API key
    
    func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, Error> {
        let url = URL(string: "\(weatherBaseURL)/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchWeatherDetail(lat: Double, lon: Double) -> AnyPublisher<WeatherDetailResponse, Error> {
        let url = URL(string: "\(weatherBaseURL)/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherDetailResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func searchCities(query: String) -> AnyPublisher<[CityResponse], Error> {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let url = URL(string: "\(geoBaseURL)/direct?q=\(encodedQuery)&limit=5&appid=\(apiKey)")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [CityResponse].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
