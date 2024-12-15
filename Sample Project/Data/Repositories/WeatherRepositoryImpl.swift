//
//  WeatherRepositoryImpl.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation
import Combine

class WeatherRepositoryImpl: WeatherRepository {
    private let apiService: OpenWeatherMapService
    
    init(apiService: OpenWeatherMapService) {
        self.apiService = apiService
    }
    
    func fetchWeather(lat: Double, lon: Double, cityName: String) -> AnyPublisher<Weather, Error> {
        apiService.fetchWeather(lat: lat, lon: lon)
            .map { response in
                Weather(
                    cityName: cityName,
                    temperature: response.main.temp,
                    description: response.weather.first?.description ?? "",
                    humidity: response.main.humidity,
                    windSpeed: response.wind.speed,
                    icon: response.weather.first?.icon ?? "",
                    lat: lat,
                    lon: lon
                )
            }
            .eraseToAnyPublisher()
    }
    
    func fetchWeatherDetail(lat: Double, lon: Double, cityName: String) -> AnyPublisher<WeatherDetail, Error> {
        Publishers.Zip(
            apiService.fetchWeather(lat: lat, lon: lon),
            apiService.fetchWeatherDetail(lat: lat, lon: lon)
        )
        .map { currentResponse, detailResponse in
            let current = Weather(
                cityName: cityName,
                temperature: currentResponse.main.temp,
                description: currentResponse.weather.first?.description ?? "",
                humidity: currentResponse.main.humidity,
                windSpeed: currentResponse.wind.speed,
                icon: currentResponse.weather.first?.icon ?? "",
                lat: lat,
                lon: lon
            )
            
            let hourly = detailResponse.list.prefix(8).map { item in
                Weather(
                    cityName: cityName,
                    temperature: item.main.temp,
                    description: item.weather.first?.description ?? "",
                    humidity: item.main.humidity,
                    windSpeed: item.wind.speed,
                    icon: item.weather.first?.icon ?? "",
                    lat: lat,
                    lon: lon
                )
            }
            
            return WeatherDetail(
                currentWeather: current,
                hourlyForecast: Array(hourly),
                dailyForecast: [] // For simplicity
            )
        }
        .eraseToAnyPublisher()
    }
    
    func searchCities(query: String) -> AnyPublisher<[CityResponse], Error> {
        apiService.searchCities(query: query)
    }
}
