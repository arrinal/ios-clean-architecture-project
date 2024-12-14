import Foundation
import Combine

class WeatherStatisticsViewModel: ObservableObject {
    @Published var averageTemperature: Double = 0
    @Published var averageHumidity: Double = 0
    @Published var windSpeedRange: (min: Double, max: Double) = (0, 0)
    @Published var isLoading = false
    @Published var error: String?
    
    private let cityName: String
    private let lat: Double
    private let lon: Double
    private let fetchWeatherUseCase: FetchWeatherUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(cityName: String, lat: Double, lon: Double, fetchWeatherUseCase: FetchWeatherUseCase) {
        self.cityName = cityName
        self.lat = lat
        self.lon = lon
        self.fetchWeatherUseCase = fetchWeatherUseCase
        fetchStatistics()
    }
    
    private func fetchStatistics() {
        isLoading = true
        
        fetchWeatherUseCase.executeDetail(lat: lat, lon: lon, cityName: cityName)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] detail in
                    self?.calculateStatistics(from: detail)
                }
            )
            .store(in: &cancellables)
    }
    
    private func calculateStatistics(from detail: WeatherDetail) {
        let allWeather = [detail.currentWeather] + detail.hourlyForecast
        
        // Calculate average temperature
        let temperatures = allWeather.map { $0.temperature }
        averageTemperature = temperatures.reduce(0, +) / Double(temperatures.count)
        
        // Calculate average humidity
        let humidities = allWeather.map { Double($0.humidity) }
        averageHumidity = humidities.reduce(0, +) / Double(humidities.count)
        
        // Calculate wind speed range
        let windSpeeds = allWeather.map { $0.windSpeed }
        windSpeedRange = (
            min: windSpeeds.min() ?? 0,
            max: windSpeeds.max() ?? 0
        )
    }
}
