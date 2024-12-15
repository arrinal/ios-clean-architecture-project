//
//  AddCityViewModel.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import Foundation
import Combine

class AddCityViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var cities: [CityResponse] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let searchCityUseCase: SearchCityUseCase
    private var searchCancellable: AnyCancellable?
    
    init(searchCityUseCase: SearchCityUseCase) {
        self.searchCityUseCase = searchCityUseCase
        
        searchCancellable = $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = true
            })
            .flatMap { [weak self] query -> AnyPublisher<[CityResponse], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                return self.searchCityUseCase.execute(query: query)
                    .catch { error -> AnyPublisher<[CityResponse], Never> in
                        self.error = error.localizedDescription
                        return Just([]).eraseToAnyPublisher()
                    }
                    .handleEvents(receiveOutput: { [weak self] _ in
                        self?.isLoading = false
                    })
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.cities, on: self)
    }
}
