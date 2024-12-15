//
//  WeatherDetailViewModel.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation
import Combine

class WeatherDetailViewModel: ObservableObject {
    @Published var weatherDetail: WeatherDetail?
    @Published var error: String?
    
    let weather: Weather
    private let fetchWeatherUseCase: FetchWeatherUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(weather: Weather, fetchWeatherUseCase: FetchWeatherUseCase) {
        self.weather = weather
        self.fetchWeatherUseCase = fetchWeatherUseCase
        fetchWeatherDetail()
    }
    
    private func fetchWeatherDetail() {
        fetchWeatherUseCase.executeDetail(lat: weather.lat, lon: weather.lon, cityName: weather.cityName)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.error = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] detail in
                    self?.weatherDetail = detail
                }
            )
            .store(in: &cancellables)
    }
}
