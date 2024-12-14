//
//  FetchWeatherUseCase.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation
import Combine

protocol FetchWeatherUseCase {
    func execute(lat: Double, lon: Double, cityName: String) -> AnyPublisher<Weather, Error>
    func executeDetail(lat: Double, lon: Double, cityName: String) -> AnyPublisher<WeatherDetail, Error>
}
