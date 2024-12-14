import SwiftUI

struct WeatherListView: View {
    @StateObject private var viewModel: WeatherListViewModel
    @State private var showingAddCity = false
    
    init(viewModel: WeatherListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.cities) { weather in
                    NavigationLink(destination: WeatherDetailView(cityName: weather.cityName, lat: weather.lat, lon: weather.lon)) {
                        WeatherRowView(weather: weather)
                    }
                }
            }
            .refreshable {
                viewModel.refresh()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationTitle("Weather")
            .toolbar {
                Button {
                    showingAddCity = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddCity) {
                AddCityView { city in
                    viewModel.addCity(city)
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

struct WeatherRowView: View {
    let weather: Weather
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(weather.cityName)
                    .font(.headline)
                Text(weather.description.capitalized)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(Int(weather.temperature))°")
                .font(.title)
                .fontWeight(.bold)
        }
        .padding(.vertical, 8)
    }
}
