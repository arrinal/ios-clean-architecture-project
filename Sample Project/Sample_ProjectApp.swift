//
//  Sample_ProjectApp.swift
//  Sample Project
//
//  Created by Arrinal S on 13/12/24.
//

import SwiftUI

@main
struct Sample_ProjectApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherListView(
                viewModel: DIContainer.shared.container.resolve(WeatherListViewModel.self)!
            )
        }
    }
}
