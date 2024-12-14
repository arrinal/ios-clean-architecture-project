//
//  Sample_ProjectApp.swift
//  Sample Project
//
//  Created by Arrinal S on 13/12/24.
//

import SwiftUI

@main
struct Sample_ProjectApp: App {
    // Hold a reference to ensure DIContainer lives throughout app lifecycle
    private let sharedContainer = DIContainer.shared
    
    var body: some Scene {
        WindowGroup {
            WeatherListView(
                viewModel: sharedContainer.container.resolve(WeatherListViewModel.self)!
            )
        }
    }
}
