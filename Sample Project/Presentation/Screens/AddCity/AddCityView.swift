import SwiftUI
import Combine

struct AddCityView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddCityViewModel
    
    let onCitySelected: (CityResponse) -> Void
    
    init(onCitySelected: @escaping (CityResponse) -> Void) {
        self.onCitySelected = onCitySelected
        let repository = DIContainer.shared.container.resolve(WeatherRepository.self)!
        _viewModel = StateObject(wrappedValue: AddCityViewModel(repository: repository))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.cities, id: \.displayName) { city in
                    Button {
                        onCitySelected(city)
                        dismiss()
                    } label: {
                        VStack(alignment: .leading) {
                            Text(city.name)
                                .font(.headline)
                            Text(city.displayName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search for a city")
            .navigationTitle("Add City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
            }
            .alert("Error", isPresented: .constant(viewModel.error != nil)) {
                Button("OK") {
                    viewModel.error = nil
                }
            } message: {
                Text(viewModel.error ?? "")
            }
        }
    }
}

class AddCityViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var cities: [CityResponse] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let repository: WeatherRepository
    private var searchCancellable: AnyCancellable?
    
    init(repository: WeatherRepository) {
        self.repository = repository
        
        searchCancellable = $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = true
            })
            .flatMap { [weak self] query -> AnyPublisher<[CityResponse], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                return self.repository.searchCities(query: query)
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
