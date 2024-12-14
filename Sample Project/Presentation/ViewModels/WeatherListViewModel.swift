import Foundation
import Combine

class WeatherListViewModel: ObservableObject {
    @Published var cities: [Weather] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let fetchWeatherUseCase: FetchWeatherUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(fetchWeatherUseCase: FetchWeatherUseCase) {
        self.fetchWeatherUseCase = fetchWeatherUseCase
        loadDefaultCities()
    }
    
    private func loadDefaultCities() {
        let defaultCities = [
            (name: "London", lat: 51.5074, lon: -0.1278),
            (name: "New York", lat: 40.7128, lon: -74.0060),
            (name: "Tokyo", lat: 35.6762, lon: 139.6503)
        ]
        
        isLoading = true
        
        Publishers.MergeMany(
            defaultCities.map { city in
                fetchWeatherUseCase.execute(lat: city.lat, lon: city.lon, cityName: city.name)
            }
        )
        .collect()
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            },
            receiveValue: { [weak self] weather in
                self?.cities = weather
            }
        )
        .store(in: &cancellables)
    }
    
    func refresh() {
        loadDefaultCities()
    }
    
    func addCity(_ cityResponse: CityResponse) {
        fetchWeatherUseCase.execute(lat: cityResponse.lat, lon: cityResponse.lon, cityName: cityResponse.name)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.error = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] weather in
                    self?.cities.append(weather)
                }
            )
            .store(in: &cancellables)
    }
}
