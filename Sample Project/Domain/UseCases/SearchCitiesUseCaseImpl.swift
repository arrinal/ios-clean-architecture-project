//
//  SearchCitiesUseCaseImpl.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation
import Combine

class SearchCitiesUseCaseImpl: SearchCitiesUseCase {
    private let repository: SearchCitiesRepository
    
    init(repository: SearchCitiesRepository) {
        self.repository = repository
    }
    
    func execute(query: String) -> AnyPublisher<[CityResponse], Error> {
        repository.searchCities(query: query)
    }
}
