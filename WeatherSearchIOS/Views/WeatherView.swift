import SwiftUI

extension Notification.Name {
    static let cityCoordinatesUpdated = Notification.Name("cityCoordinatesUpdated")
}


struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel() // Weather ViewModel
    @StateObject private var locationManager = LocationManager() // Location Manager
    @StateObject private var autocompleteViewModel = AutocompleteViewModel() // Autocomplete ViewModel
    @State private var cityName: String = "" // Bind to the SearchBarView

    var body: some View {
        ZStack(alignment: .top) {
            Image("App_background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                SearchBarView(cityName: $cityName, viewModel: autocompleteViewModel)
                    .onChange(of: cityName) { newValue in
                        fetchWeatherForCity(newValue)
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
        .onAppear {
            // Fetch weather data for the user's current location on app launch
            fetchWeatherForCurrentLocation()
        }
    }

    // Fetch weather data based on the user's current location
    private func fetchWeatherForCurrentLocation() {
        guard locationManager.latitude != 0, locationManager.longitude != 0 else { return }
        viewModel.fetchWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
        viewModel.cityName = locationManager.cityName
    }

    // Fetch weather data for a manually entered city
    private func fetchWeatherForCity(_ city: String) {
        // Trigger geocoding or fetch based on user input
        GeocodingController().fetchCoordinates(for: city) { result in
            switch result {
            case .success(let coordinates):
                NotificationCenter.default.post(name: .cityCoordinatesUpdated, object: coordinates)
            case .failure(let error):
                print("Error fetching coordinates: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    WeatherView()
}
