import Foundation
import Combine

class WeatherListViewModel: ObservableObject {
    @Published var cities: [Weather] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let fetchWeatherUseCase: FetchWeatherUseCase
    private let storage: WeatherStorage
    private var cancellables = Set<AnyCancellable>()
    
    init(fetchWeatherUseCase: FetchWeatherUseCase, storage: WeatherStorage) {
        self.fetchWeatherUseCase = fetchWeatherUseCase
        self.storage = storage
        loadSavedCities()
    }
    
    private func loadSavedCities() {
        isLoading = true
        
        storage.loadCities()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error.localizedDescription
                        self?.loadDefaultCities()
                    }
                },
                receiveValue: { [weak self] savedCities in
                    if savedCities.isEmpty {
                        self?.loadDefaultCities()
                    } else {
                        self?.cities = savedCities
                        self?.isLoading = false
                    }
                }
            )
            .store(in: &cancellables)
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
                self?.saveCities(weather)
            }
        )
        .store(in: &cancellables)
    }
    
    func refresh() {
        let currentCities = cities
        Publishers.MergeMany(
            currentCities.map { city in
                fetchWeatherUseCase.execute(lat: city.lat, lon: city.lon, cityName: city.cityName)
            }
        )
        .collect()
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            },
            receiveValue: { [weak self] weather in
                self?.cities = weather
                self?.saveCities(weather)
            }
        )
        .store(in: &cancellables)
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
                    if let cities = self?.cities {
                        self?.saveCities(cities)
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    private func saveCities(_ cities: [Weather]) {
        storage.saveCities(cities)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.error = error.localizedDescription
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
}
