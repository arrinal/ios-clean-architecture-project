import Foundation
import Combine

class WeatherDetailViewModel: ObservableObject {
    @Published var weatherDetail: WeatherDetail?
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
        fetchWeatherDetail()
    }
    
    private func fetchWeatherDetail() {
        fetchWeatherUseCase.executeDetail(lat: lat, lon: lon, cityName: cityName)
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
