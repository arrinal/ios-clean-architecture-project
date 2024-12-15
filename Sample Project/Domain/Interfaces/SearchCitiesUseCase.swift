//
//  SearchCitiesUseCase.swift
//  Sample Project
//
//  Created by Arrinal S on 5/12/24.
//

import Foundation
import Combine

protocol SearchCitiesUseCase {
    func execute(query: String) -> AnyPublisher<[CityResponse], Error>
}
