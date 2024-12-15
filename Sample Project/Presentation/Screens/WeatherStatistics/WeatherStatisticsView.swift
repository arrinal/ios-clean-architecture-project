//
//  WeatherStatisticsView.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import SwiftUI

struct WeatherStatisticsView: View {
    @StateObject var viewModel: WeatherStatisticsViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    StatisticCard(
                        title: "Average Temperature",
                        value: String(format: "%.1f°", viewModel.averageTemperature),
                        icon: "thermometer"
                    )
                    
                    StatisticCard(
                        title: "Average Humidity",
                        value: String(format: "%.0f%%", viewModel.averageHumidity),
                        icon: "humidity"
                    )
                    
                    StatisticCard(
                        title: "Wind Speed Range",
                        value: String(format: "%.1f - %.1f km/h",
                                    viewModel.windSpeedRange.min,
                                    viewModel.windSpeedRange.max),
                        icon: "wind"
                    )
                }
            }
            .padding()
        }
        .navigationTitle("\(viewModel.weather.cityName) Statistics")
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                viewModel.error = nil
            }
        } message: {
            Text(viewModel.error ?? "")
        }
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.headline)
            }
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
}
