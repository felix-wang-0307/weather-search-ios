import SwiftUI
import Combine

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var autocompleteViewModel = AutocompleteViewModel()
    @State private var cityName: String = ""
    @State private var selectedCity: String? = nil
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
                    .onTapGesture {
                        // Tap background to dismiss suggestions
                        showSuggestions = false
                    }
                
                ScrollView {
                    VStack(spacing: 20) {
                        // UISearchBar
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
                        
                        // Make WeatherSummaryView clickable
                        Button(action: {
                            selectedCity = viewModel.cityName
                        }) {
                            WeatherSummaryView(viewModel: viewModel)
                                .padding(.horizontal, 15)
                        }
                        .buttonStyle(PlainButtonStyle()) // No default button styling
                        
                        WeatherDetailsView(viewModel: viewModel)
                            .padding(.horizontal, 15)
                        WeeklyWeatherView(viewModel: viewModel)
                            .padding(.horizontal, 15)
                    }
                    .padding()
                }
                
                // Suggestions table just below the search bar
                if showSuggestions && !autocompleteViewModel.suggestions.isEmpty {
                    UIKitSuggestionsTableView(
                        suggestions: autocompleteViewModel.suggestions,
                        onSelect: { suggestion in
                            cityName = suggestion.city
                            showSuggestions = false
                            selectedCity = suggestion.city
                        }
                    )
                    .frame(maxWidth: searchBarFrame.width, maxHeight: 200)
                    .position(x: searchBarFrame.midX, y: searchBarFrame.maxY + 5)
                }
                
                // Navigation to CityDetailView
                NavigationLink(
                    destination: WeatherTabView(cityName: selectedCity ?? viewModel.cityName),
                    tag: selectedCity ?? viewModel.cityName,
                    selection: $selectedCity
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .onAppear {
                // Try fetching weather for current location if available
                if locationManager.cityName != "Unknown" {
                    viewModel.fetchWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    viewModel.cityName = locationManager.cityName
                } else {
                    fetchWeatherForCurrentLocation()
                }
            }
            // Listen for changes in locationManager.cityName
            .onReceive(locationManager.$cityName) { newCityName in
                // If no manual city is selected yet, use this new city
                if newCityName != "Unknown" {
                    viewModel.fetchWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    viewModel.cityName = newCityName
                } else {
                    fetchWeatherForCurrentLocation()
                    selectedCity = viewModel.cityName
                }
            }
        }
    }
    
    private func fetchWeatherForCurrentLocation() {
        viewModel.fetchWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
    }
    
    private func fetchWeatherForCity(_ city: String) {
        debugPrint(city)
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
