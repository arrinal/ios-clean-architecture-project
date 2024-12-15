# Weather App - Clean Architecture with SwiftUI

A weather application built using SwiftUI and following Clean Architecture principles. The app demonstrates the implementation of SOLID principles, dependency injection, and reactive programming with Combine, backed by a Swift Vapor backend service.

## Features

- View current weather information for cities
- Search and add new cities
- View detailed weather forecasts
- View weather statistics (temperature, humidity, wind speed)
- Persistent storage of favorite cities
- Offline support for previously loaded cities
- Backend service for API handling and data transformation

## Architecture

The project follows Clean Architecture principles with the following layers:

### Domain Layer
- Contains business logic and entities
- Independent of other layers
- Located in `/Domain` directory
  - `/Entities`: Core business models
  - `/Interfaces`: Protocols defining boundaries
  - `/UseCases`: Business logic implementations

### Data Layer
- Implements data operations
- Located in `/Data` directory
  - `/Network`: API services and endpoints
  - `/Models`: Data transfer objects
  - `/Repositories`: Repository implementations
  - `/Storage`: Local storage implementations
  - `/Base`: Base networking (BaseService)
  - `/Endpoints`: API endpoints

### Presentation Layer
- Contains UI-related code
- Located in `/Presentation` directory
  - `/Screens`: SwiftUI views
  - `/ViewModels`: Presentation logic

### Application Layer
- Contains app-wide configurations
- Located in `/Application` directory
  - DIContainer: Dependency injection setup
  - App lifecycle management

## Backend Service

Built with Swift Vapor, the backend service provides:
- Weather data from OpenWeatherMap API
- City search functionality
- Current weather and forecast endpoints
- Standardized API response format

Backend service repository: [sample-service-swift-vapor](https://github.com/arrinal/sample-service-swift-vapor)

### API Endpoints
- `/api/v1/openweathermap.org/current-weather`: Get current weather
- `/api/v1/openweathermap.org/current-forecast`: Get weather forecast
- `/api/v1/openweathermap.org/search-cities`: Search for cities

## Dependencies

### iOS App
- **SwiftUI**: UI framework
- **Combine**: Reactive programming
- **Swinject**: Dependency injection
- **BaseService**: Network layer abstraction
- **OpenWeatherMap API**: Weather data source

### Backend Service
- **Vapor**: Server-side Swift framework
- **async/await**: Asynchronous programming
- **OpenWeatherMap API**: Weather data provider

## Key Design Decisions

1. **Clean Architecture**
   - Clear separation of concerns
   - Dependencies point inward
   - Domain layer is independent

2. **Dependency Injection**
   - Using Swinject for DI container
   - Centralized container management
   - Singleton pattern for shared container
   - Scoped object instances

3. **Reactive Programming**
   - Using Combine for async operations
   - Reactive data flow
   - Error handling

4. **Backend Integration**
   - Dedicated Swift Vapor service
   - Standardized API responses
   - Error handling and data transformation

5. **Local Storage**
   - UserDefaults for city persistence
   - Offline-first approach
   - Automatic saving of added cities

## Project Structure

```
Sample Project/
├── Application/
│   └── DIContainer.swift
├── Data/
│   ├── Network/
│   │   ├── Base/
│   │   │   └── BaseService.swift
│   │   ├── Endpoints/
│   │   │   ├── Endpoint.swift
│   │   │   └── WeatherEndpoint.swift
│   │   └── OpenWeatherMapService.swift
│   ├── Models/
│   │   ├── BaseServiceResponse.swift
│   │   ├── CityResponse.swift
│   │   └── WeatherResponse.swift
│   ├── Repositories/
│   │   ├── FetchWeatherRepositoryImpl.swift
│   │   └── SearchCitiesRepositoryImpl.swift
│   └── Storage/
│       └── UserDefaultsWeatherStorageImpl.swift
├── Domain/
│   ├── Entities/
│   │   └── Weather.swift
│   ├── Interfaces/
│   │   ├── FetchWeatherRepository.swift
│   │   ├── FetchWeatherUseCase.swift
│   │   ├── SearchCitiesRepository.swift
│   │   ├── SearchCitiesUseCase.swift
│   │   └── WeatherStorage.swift
│   └── UseCases/
│       ├── FetchWeatherUseCaseImpl.swift
│       └── SearchCitiesUseCaseImpl.swift
└── Presentation/
    ├── Screens/
    │   ├── AddCity/
    │   │   └── AddCityView.swift
    │   ├── WeatherDetail/
    │   │   └── WeatherDetailView.swift
    │   ├── WeatherList/
    │   │   └── WeatherListView.swift
    │   └── WeatherStatistics/
    │       └── WeatherStatisticsView.swift
    └── ViewModels/
        ├── AddCityViewModel.swift
        ├── WeatherDetailViewModel.swift
        ├── WeatherListViewModel.swift
        └── WeatherStatisticsViewModel.swift
```

## Getting Started

1. Clone the repository
2. Set up the backend service:
   - Navigate to the `Backend Swift Vapor` directory
   - Add your OpenWeatherMap API key to the environment
   - Run `swift run` to start the server
3. Set up the iOS app:
   - Open the Xcode project
   - Update the backend service URL if needed
   - Build and run the project

## Project Specifications

- iOS 18.0+
- Xcode 16.0+
- Swift 6+
- Vapor 4.0+ (for backend service)
