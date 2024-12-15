//
//  SearchCitiesRepositoryImpl.swift
//  Sample Project
//
//  Created by Arrinal S on 15/12/24.
//

import Foundation
import Combine

class SearchCitiesRepositoryImpl: SearchCitiesRepository {
    private let apiService: OpenWeatherMapService
    
    init(apiService: OpenWeatherMapService) {
        self.apiService = apiService
    }
    
    func searchCities(query: String) -> AnyPublisher<[CityResponse], Error> {
        apiService.searchCities(query: query)
    }
}
