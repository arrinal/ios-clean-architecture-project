import Foundation
import Combine

protocol WeatherStorage {
    func saveCities(_ cities: [Weather]) -> AnyPublisher<Void, Error>
    func loadCities() -> AnyPublisher<[Weather], Error>
}

class UserDefaultsWeatherStorage: WeatherStorage {
    private let userDefaults: UserDefaults
    private let citiesKey = "saved_cities"
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveCities(_ cities: [Weather]) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            do {
                let data = try self.encoder.encode(cities)
                self.userDefaults.set(data, forKey: self.citiesKey)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func loadCities() -> AnyPublisher<[Weather], Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            if let data = self.userDefaults.data(forKey: self.citiesKey) {
                do {
                    let cities = try self.decoder.decode([Weather].self, from: data)
                    promise(.success(cities))
                } catch {
                    promise(.failure(error))
                }
            } else {
                promise(.success([]))
            }
        }
        .eraseToAnyPublisher()
    }
}
