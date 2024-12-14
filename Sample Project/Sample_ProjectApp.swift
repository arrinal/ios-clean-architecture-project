//
//  Sample_ProjectApp.swift
//  Sample Project
//
//  Created by Arrinal S on 13/12/24.
//

import SwiftUI

@main
struct Sample_ProjectApp: App {
    init() {
        // Initialize dependency container
        _ = DIContainer.shared
    }
    
    var body: some Scene {
        WindowGroup {
            WeatherListView(
                viewModel: DIContainer.shared.container.resolve(WeatherListViewModel.self)!
            )
        }
    }
}
