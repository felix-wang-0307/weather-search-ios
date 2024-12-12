import SwiftUI
import Combine
import UIKit
import CoreLocation

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var autocompleteViewModel = AutocompleteViewModel()
    @State private var cityName: String = ""
    @State private var selectedCity: String = ""
    @State private var showSuggestions: Bool = false
    @State private var searchBarFrame: CGRect = .zero
    private let searchBarController: SearchBarController

    init() {
        let autocompleteViewModel = AutocompleteViewModel()
        self._autocompleteViewModel = StateObject(wrappedValue: autocompleteViewModel)
        self.searchBarController = SearchBarController(viewModel: autocompleteViewModel)
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Image("App_background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 20) {
                        // UISearchBar integrated via UIViewRepresentable
                        UIKitSearchBar(text: $cityName, onTextChanged: { newText in
                            searchBarController.onTextChanged(newText)
                            showSuggestions = !newText.isEmpty && !autocompleteViewModel.suggestions.isEmpty
                        })
                        .background(
                            GeometryReader { geo in
                                Color.clear.onAppear {
                                    searchBarFrame = geo.frame(in: .global)
                                }
                            }
                        )

                        // Display weather summaries as before
                        WeatherSummaryView(viewModel: viewModel)
                            .padding(.horizontal, 15)
                        WeatherDetailsView(viewModel: viewModel)
                            .padding(.horizontal, 15)
                        WeeklyWeatherView(viewModel: viewModel)
                            .padding(.horizontal, 15)
                    }
                    .padding()
                }

                // Suggestions dropdown
                if showSuggestions {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showSuggestions = false
                        }

                    VStack {
                        Spacer().frame(height: searchBarFrame.maxY)
                        SuggestionsDropdownView(
                            suggestions: autocompleteViewModel.suggestions,
                            onSelect: { suggestion in
                                cityName = suggestion.city
                                showSuggestions = false
                                handleCitySelection(suggestion.city)
                            }
                        )
                        .padding(.horizontal)
                    }
                }
            }
            .onAppear {
                fetchWeatherForCurrentLocation()
            }
            .onReceive(locationManager.$cityName
                        .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                        .removeDuplicates()) { newCityName in
                viewModel.cityName = newCityName
                fetchWeatherForCity(newCityName)
            }
        }
    }

    // Handle city selection
    private func handleCitySelection(_ city: String) {
        selectedCity = city
        fetchWeatherForCity(city)
    }

    private func fetchWeatherForCurrentLocation() {
        guard locationManager.latitude != 0, locationManager.longitude != 0 else { return }
        viewModel.fetchWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
        viewModel.cityName = locationManager.cityName
    }

    private func fetchWeatherForCity(_ city: String) {
        GeocodingController().fetchCoordinates(for: city) { result in
            switch result {
            case .success(let coordinates):
                viewModel.fetchWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                viewModel.cityName = city
            case .failure(let error):
                print("Error fetching coordinates: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    WeatherView()
}
