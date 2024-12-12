import SwiftUI

struct WeatherView: View {
    @StateObject private var locationManager = LocationManager() // Location Manager
    @StateObject private var viewModel: WeatherViewModel // Weather ViewModel
    @StateObject private var autocompleteViewModel = AutocompleteViewModel() // Autocomplete ViewModel
    @State private var cityName: String = "" // Bind to the SearchBarView
    @State private var selectedCity: String = "" // Track selected city
    private let searchBarController: SearchBarController

    init() {
        let locationManager = LocationManager()
        let autocompleteViewModel = AutocompleteViewModel()
        let viewModel = WeatherViewModel(locationManager: locationManager)

        self._locationManager = StateObject(wrappedValue: locationManager)
        self._viewModel = StateObject(wrappedValue: viewModel)
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
                    // Search Bar
                    SearchBarView(
                        cityName: $cityName,
                        viewModel: autocompleteViewModel,
                        controller: searchBarController
                    ) { selectedCity in
                        handleCitySelection(selectedCity)
                    }
                    .padding()

                    // Weather Views
                    WeatherSummaryView(viewModel: viewModel)
                        .padding(.horizontal, 15)
                    WeatherDetailsView(viewModel: viewModel)
                        .padding(.horizontal, 15)
                    WeeklyWeatherView(viewModel: viewModel)
                        .padding(.horizontal, 15)
                }
                .padding()
            }
        }
        .onAppear {
            fetchWeatherForCurrentLocation()
        }
    }

    private func fetchWeatherForCurrentLocation() {
        guard locationManager.latitude != 0, locationManager.longitude != 0 else { return }
        viewModel.fetchWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
    }

    private func handleCitySelection(_ city: String) {
        selectedCity = city
        viewModel.cityName = city
    }
}

#Preview {
    WeatherView()
}
