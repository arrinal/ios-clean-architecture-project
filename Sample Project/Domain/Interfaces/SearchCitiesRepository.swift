//
//  SearchCitiesRepository.swift
//  Sample Project
//
//  Created by Arrinal S on 15/12/24.
//

import Foundation
import Combine

protocol SearchCitiesRepository {
    func searchCities(query: String) -> AnyPublisher<[CityResponse], Error>
}
