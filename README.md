# Weather App - Clean Architecture with SwiftUI

A simple weather application that demonstrates clean architecture principles, SOLID, and modern iOS development practices.

## Architecture Overview

This project follows Clean Architecture principles with the following layers:

1. **Presentation Layer (UI)**
   - SwiftUI Views
   - ViewModels
   - UI Models

2. **Domain Layer**
   - Use Cases
   - Domain Models
   - Repository Interfaces

3. **Data Layer**
   - Repositories Implementation
   - API Services
   - Data Models

## Key Features

- Clean Architecture implementation
- SOLID principles
- Dependency Injection using Swinject
- Reactive Programming with Combine
- Network API integration with OpenWeatherMap
- Modular Design

## Project Structure

```
WeatherApp/
├── Application/
│   └── DIContainer
├── Presentation/
│   ├── Screens/
│   │   ├── WeatherList/
│   │   ├── WeatherDetail/
│   │   └── AddCity/
│   └── Components/
├── Domain/
│   ├── Entities/
│   ├── UseCases/
│   └── Interfaces/
└── Data/
    ├── Repositories/
    ├── Network/
    └── Models/
```

## Screens

1. **Weather List**
   - Displays a list of cities with their current weather
   - Pull to refresh functionality
   - Navigation to detail view

2. **Weather Detail**
   - Shows detailed weather information for a selected city
   - Displays temperature, humidity, wind speed, etc.
   - 24-hour forecast

3. **Add City**
   - Search for cities
   - Add cities to tracking list

## Dependencies

- Swinject for Dependency Injection
- Combine for Reactive Programming

## Getting Started

1. Clone the repository
2. Open `Sample Project.xcodeproj`
3. Build and run the project

## Clean Architecture Flow

1. **User Action Flow**
   - User interacts with View
   - View notifies ViewModel
   - ViewModel executes Use Case
   - Use Case works with Repository
   - Repository fetches data from API/Local Storage
   - Data flows back through the chain

2. **Data Flow**
   - API → Data Models → Domain Models → UI Models → View

## SOLID Principles Implementation

1. **Single Responsibility**
   - Each class has one specific purpose
   - Clear separation of concerns

2. **Open/Closed**
   - Use protocols for extensibility
   - New features can be added without modifying existing code

3. **Liskov Substitution**
   - All implementations can replace their abstractions

4. **Interface Segregation**
   - Small, specific protocols instead of large ones

5. **Dependency Inversion**
   - High-level modules don't depend on low-level modules
   - Both depend on abstractions

## Best Practices

- Protocol-oriented programming
- Dependency injection
- Reactive programming with Combine
- SwiftUI best practices
- Error handling
- Unit testing ready structure
