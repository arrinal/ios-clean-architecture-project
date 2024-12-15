//
//  AddCityView.swift
//  Sample Project
//
//  Created by Arrinal S on 14/12/24.
//

import SwiftUI
import Combine

struct AddCityView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: AddCityViewModel
    let onCitySelected: (CityResponse) -> Void
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.cities, id: \.displayName) { city in
                    Button {
                        onCitySelected(city)
                        dismiss()
                    } label: {
                        VStack(alignment: .leading) {
                            Text(city.name)
                                .font(.headline)
                            Text(city.displayName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search for a city")
            .navigationTitle("Add City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Cancel") {
                    dismiss()
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
