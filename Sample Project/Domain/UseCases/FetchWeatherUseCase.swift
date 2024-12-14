import Foundation
import Combine

protocol FetchWeatherUseCase {
    func execute(lat: Double, lon: Double, cityName: String) -> AnyPublisher<Weather, Error>
    func executeDetail(lat: Double, lon: Double, cityName: String) -> AnyPublisher<WeatherDetail, Error>
}

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
