import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel() // Weather ViewModel
    @StateObject private var locationManager = LocationManager() // Location Manager
    @StateObject private var autocompleteViewModel = AutocompleteViewModel() // Autocomplete ViewModel
    @State private var cityName: String = "" // Bind to the SearchBarView
    @State private var selectedCity: String = "" // Track selected city
    @State private var showSuggestions: Bool = false // Control visibility of dropdown
    @State private var searchBarFrame: CGRect = .zero // Track search bar position
    private let searchBarController: SearchBarController

    init() {
        let autocompleteViewModel = AutocompleteViewModel()
        self._autocompleteViewModel = StateObject(wrappedValue: autocompleteViewModel)
        self.searchBarController = SearchBarController(viewModel: autocompleteViewModel)
    }

    var body: some View {
        ZStack(alignment: .top) {
            // Background Image
            Image("App_background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            // Main Content ScrollView
            ScrollView {
                VStack(spacing: 20) {
                    // Search Bar with Dropdown
                    SearchBarView(cityName: $cityName, viewModel: autocompleteViewModel, controller: searchBarController) { selectedCity in
                        handleCitySelection(selectedCity)
                    }
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    searchBarFrame = geo.frame(in: .global) // Capture search bar frame
                                }
                        }
                    )
                    .onChange(of: cityName) { _ in
                        // Toggle suggestions based on input
                        showSuggestions = !cityName.isEmpty && !autocompleteViewModel.suggestions.isEmpty
                    }

                    WeatherSummaryView(viewModel: viewModel)
                        .padding(.horizontal, 15)
                    WeatherDetailsView(viewModel: viewModel)
                        .padding(.horizontal, 15)
                    WeeklyWeatherView(viewModel: viewModel)
                        .padding(.horizontal, 15)
                }
                .padding()
            }

            // Dropdown Layer
            if showSuggestions {
                // Background overlay to block interaction with underlying views
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // Dismiss dropdown on tap
                        showSuggestions = false
                    }

                // Dropdown positioned below the search bar
                VStack {
                    Spacer().frame(height: searchBarFrame.maxY) // Push to the correct position
                    SuggestionsDropdownView(
                        suggestions: autocompleteViewModel.suggestions,
                        onSelect: { suggestion in
                            cityName = suggestion.city
                            showSuggestions = false // Hide dropdown
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
    }

    // Handle city selection
    private func handleCitySelection(_ city: String) {
        selectedCity = city
        fetchWeatherForCity(city)
    }

    // Fetch weather data based on the user's current location
    private func fetchWeatherForCurrentLocation() {
        guard locationManager.latitude != 0, locationManager.longitude != 0 else { return }
        viewModel.fetchWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
        viewModel.cityName = locationManager.cityName
    }

    // Fetch weather data for a selected city
    private func fetchWeatherForCity(_ city: String) {
        GeocodingController().fetchCoordinates(for: city) { result in
            switch result {
            case .success(let coordinates):
                viewModel.fetchWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                viewModel.cityName = city // Update city name in the ViewModel
            case .failure(let error):
                print("Error fetching coordinates: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    WeatherView()
}
