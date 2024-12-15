//
//  WeatherListView.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import SwiftUI

struct WeatherListView: View {
    @StateObject var viewModel: WeatherListViewModel
    @State private var showingAddCity = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.cities) { weather in
                    NavigationLink(
                        destination: WeatherDetailView(
                            viewModel: DIContainer.shared.container.resolve(
                                WeatherDetailViewModel.self,
                                argument: weather
                            )!
                        )
                    ) {
                        WeatherRowView(weather: weather)
                    }
                }
            }
            .refreshable {
                viewModel.refresh()
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
                AddCityView(viewModel: DIContainer.shared.container.resolve(AddCityViewModel.self)!) { city in
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
