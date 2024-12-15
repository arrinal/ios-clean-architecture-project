//
//  FetchWeatherRepository.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation
import Combine

protocol FetchWeatherRepository {
    func fetchWeather(lat: Double, lon: Double, cityName: String) -> AnyPublisher<Weather, Error>
    func fetchWeatherDetail(lat: Double, lon: Double, cityName: String) -> AnyPublisher<WeatherDetail, Error>
}
