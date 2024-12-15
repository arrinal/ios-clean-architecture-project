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
        container.register(OpenWeatherMapService.self) { _ in
            OpenWeatherMapServiceImpl()
        }.inObjectScope(.container)
    }
    
    private func registerRepositories() {
        container.register(WeatherRepository.self) { resolver in
            let apiService = resolver.resolve(OpenWeatherMapService.self)!
            return WeatherRepositoryImpl(apiService: apiService)
        }.inObjectScope(.container)
        
        container.register(SearchCitiesRepository.self) { resolver in
            let apiService = resolver.resolve(OpenWeatherMapService.self)!
            return SearchCitiesRepositoryImpl(apiService: apiService)
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
        
        container.register(SearchCityUseCase.self) { resolver in
            let repository = resolver.resolve(SearchCitiesRepository.self)!
            return SearchCityUseCaseImpl(repository: repository)
        }
    }
    
    private func registerViewModels() {
        // Register WeatherListViewModel
        container.register(WeatherListViewModel.self) { resolver in
            let useCase = resolver.resolve(FetchWeatherUseCase.self)!
            let storage = resolver.resolve(WeatherStorage.self)!
            return WeatherListViewModel(fetchWeatherUseCase: useCase, storage: storage)
        }
        
        // Register AddCityViewModel
        container.register(AddCityViewModel.self) { resolver in
            let useCase = resolver.resolve(SearchCityUseCase.self)!
            return AddCityViewModel(searchCityUseCase: useCase)
        }
        
        // Register WeatherDetailViewModel
        container.register(WeatherDetailViewModel.self) { (resolver, weather: Weather) in
            let useCase = resolver.resolve(FetchWeatherUseCase.self)!
            return WeatherDetailViewModel(weather: weather, fetchWeatherUseCase: useCase)
        }
        
        // Register WeatherStatisticsViewModel
        container.register(WeatherStatisticsViewModel.self) { (resolver, weather: Weather) in
            let useCase = resolver.resolve(FetchWeatherUseCase.self)!
            return WeatherStatisticsViewModel(weather: weather, fetchWeatherUseCase: useCase)
        }
    }
}
