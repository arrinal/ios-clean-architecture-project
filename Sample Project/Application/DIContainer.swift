//
//  DIContainer.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation
import Swinject

class DIContainer {
    @MainActor static let shared = DIContainer()
    let container = Container()
    
    private init() {
        registerServices()
        registerRepositories()
        registerStorage()
        registerUseCases()
        registerViewModels()
    }
    
    private func registerServices() {
        container.register(WeatherAPIService.self) { _ in
            WeatherAPIServiceImpl()
        }.inObjectScope(.container)
    }
    
    private func registerRepositories() {
        container.register(WeatherRepository.self) { resolver in
            let apiService = resolver.resolve(WeatherAPIService.self)!
            return WeatherRepositoryImpl(apiService: apiService)
        }.inObjectScope(.container)
    }
    
    private func registerStorage() {
        container.register(WeatherStorage.self) { _ in
            UserDefaultsWeatherStorageImpl()
        }.inObjectScope(.container)
    }
    
    private func registerUseCases() {
        container.register(FetchWeatherUseCase.self) { resolver in
            let repository = resolver.resolve(WeatherRepository.self)!
            return FetchWeatherUseCaseImpl(repository: repository)
        }
    }
    
    private func registerViewModels() {
        // Register WeatherListViewModel
        container.register(WeatherListViewModel.self) { resolver in
            let useCase = resolver.resolve(FetchWeatherUseCase.self)!
            let storage = resolver.resolve(WeatherStorage.self)!
            return WeatherListViewModel(fetchWeatherUseCase: useCase, storage: storage)
        }
        
        // Register WeatherDetailViewModel
        container.register(WeatherDetailViewModel.self) { (resolver, cityName: String, lat: Double, lon: Double) in
            let useCase = resolver.resolve(FetchWeatherUseCase.self)!
            return WeatherDetailViewModel(cityName: cityName, lat: lat, lon: lon, fetchWeatherUseCase: useCase)
        }
        
        // Register WeatherStatisticsViewModel
        container.register(WeatherStatisticsViewModel.self) { (resolver, cityName: String, lat: Double, lon: Double) in
            let useCase = resolver.resolve(FetchWeatherUseCase.self)!
            return WeatherStatisticsViewModel(cityName: cityName, lat: lat, lon: lon, fetchWeatherUseCase: useCase)
        }
    }
}
