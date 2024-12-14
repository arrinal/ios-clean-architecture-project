import SwiftUI

struct WeatherDetailView: View {
    let cityName: String
    let lat: Double
    let lon: Double
    @StateObject private var viewModel: WeatherDetailViewModel
    
    init(cityName: String, lat: Double, lon: Double) {
        self.cityName = cityName
        self.lat = lat
        self.lon = lon
        let useCase = DIContainer.shared.container.resolve(FetchWeatherUseCase.self)!
        _viewModel = StateObject(wrappedValue: WeatherDetailViewModel(cityName: cityName, lat: lat, lon: lon, fetchWeatherUseCase: useCase))
    }
    
    var body: some View {
        ScrollView {
            if let detail = viewModel.weatherDetail {
                VStack(spacing: 20) {
                    // Current Weather
                    CurrentWeatherView(weather: detail.currentWeather)
                    
                    // Hourly Forecast
                    VStack(alignment: .leading) {
                        Text("Hourly Forecast")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(detail.hourlyForecast.indices, id: \.self) { index in
                                    HourlyWeatherView(weather: detail.hourlyForecast[index], index: index)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            } else {
                ProgressView()
            }
        }
        .navigationTitle(cityName)
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                viewModel.error = nil
            }
        } message: {
            Text(viewModel.error ?? "")
        }
    }
}

struct CurrentWeatherView: View {
    let weather: Weather
    
    var body: some View {
        VStack(spacing: 10) {
            Text("\(Int(weather.temperature))°")
                .font(.system(size: 70))
                .fontWeight(.bold)
            
            Text(weather.description.capitalized)
                .font(.title2)
            
            HStack(spacing: 20) {
                WeatherInfoItem(icon: "humidity", value: "\(weather.humidity)%")
                WeatherInfoItem(icon: "wind", value: "\(Int(weather.windSpeed)) km/h")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

struct HourlyWeatherView: View {
    let weather: Weather
    let index: Int
    
    var formattedTime: String {
        let calendar = Calendar.current
        guard let date = calendar.date(byAdding: .hour, value: index * 3, to: Date()) else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack {
            Text("\(Int(weather.temperature))°")
                .font(.headline)
            
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            } placeholder: {
                Image(systemName: "cloud.sun.fill")
                    .font(.title2)
            }
            
            Text(formattedTime)
                .font(.caption)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct WeatherInfoItem: View {
    let icon: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(value)
        }
    }
}
