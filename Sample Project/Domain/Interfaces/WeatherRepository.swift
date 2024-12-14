import Foundation
import Combine

protocol WeatherRepository {
    func fetchWeather(lat: Double, lon: Double, cityName: String) -> AnyPublisher<Weather, Error>
    func fetchWeatherDetail(lat: Double, lon: Double, cityName: String) -> AnyPublisher<WeatherDetail, Error>
    func searchCities(query: String) -> AnyPublisher<[CityResponse], Error>
}
