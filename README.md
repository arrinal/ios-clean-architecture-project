# Weather App - Clean Architecture with SwiftUI

A weather application built using SwiftUI and following Clean Architecture principles. The app demonstrates the implementation of SOLID principles, dependency injection, and reactive programming with Combine.

## Features

- View weather information for multiple cities
- Add new cities through search
- View detailed weather information including hourly forecasts
- View weather statistics (temperature, humidity, wind speed)
- Persistent storage of favorite cities
- Offline support for previously loaded cities

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
  - `/Network`: API services
  - `/Models`: Data transfer objects
  - `/Repositories`: Repository implementations
  - `/Storage`: Local storage implementations

### Presentation Layer
- Contains UI-related code
- Located in `/Presentation` directory
  - `/Screens`: SwiftUI views
  - `/ViewModels`: Presentation logic

### Application Layer
- Contains app-wide configurations
- Located in `/Application` directory
  - Dependency injection setup
  - App lifecycle management

## Dependencies

- **SwiftUI**: UI framework
- **Combine**: Reactive programming
- **Swinject**: Dependency injection
- **OpenWeatherMap API**: Weather data source

## Key Design Decisions

1. **Clean Architecture**
   - Clear separation of concerns
   - Dependencies point inward
   - Domain layer is independent

2. **Dependency Injection**
   - Using Swinject for DI
   - Centralized container management
   - Easy testing and modification

3. **Reactive Programming**
   - Using Combine for async operations
   - Reactive data flow
   - Error handling

4. **Local Storage**
   - UserDefaults for city persistence
   - Offline-first approach
   - Automatic saving of added cities

## Getting Started

1. Clone the repository
2. Replace the API key in `WeatherAPIServiceImpl` with your OpenWeatherMap API key
3. Build and run the project

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Project Structure

```
Sample Project/
├── Application/
│   └── DIContainer.swift
├── Data/
│   ├── Network/
│   │   └── WeatherAPIService.swift
│   ├── Models/
│   │   ├── CityResponse.swift
│   │   └── WeatherResponse.swift
│   ├── Repositories/
│   │   └── WeatherRepositoryImpl.swift
│   └── Storage/
│       └── UserDefaultsWeatherStorage.swift
├── Domain/
│   ├── Entities/
│   │   └── Weather.swift
│   ├── Interfaces/
│   │   ├── WeatherRepository.swift
│   │   ├── WeatherStorage.swift
│   │   └── FetchWeatherUseCase.swift
│   └── UseCases/
│       └── FetchWeatherUseCaseImpl.swift
└── Presentation/
    ├── Screens/
    │   ├── AddCity/
    │   ├── WeatherDetail/
    │   ├── WeatherList/
    │   └── WeatherStatistics/
    └── ViewModels/
        ├── WeatherDetailViewModel.swift
        ├── WeatherListViewModel.swift
        └── WeatherStatisticsViewModel.swift
```

## License

This project is available under the MIT license.
