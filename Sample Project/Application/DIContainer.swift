import Foundation
import Swinject

class DIContainer {
    @MainActor static let shared = DIContainer()
    let container = Container()
    
    private init() {
        registerServices()
        registerRepositories()
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
    
    private func registerUseCases() {
        container.register(FetchWeatherUseCase.self) { resolver in
            let repository = resolver.resolve(WeatherRepository.self)!
            return FetchWeatherUseCaseImpl(repository: repository)
        }
    }
    
    private func registerViewModels() {
        container.register(WeatherListViewModel.self) { resolver in
            let useCase = resolver.resolve(FetchWeatherUseCase.self)!
            return WeatherListViewModel(fetchWeatherUseCase: useCase)
        }
    }
}
