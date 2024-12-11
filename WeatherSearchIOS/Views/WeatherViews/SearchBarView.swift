import SwiftUI

struct SearchBarView: View {
    @Binding var cityName: String // City name binding
    @ObservedObject var viewModel: AutocompleteViewModel // Autocomplete ViewModel
    private let controller: SearchBarController // Controller for autocomplete and geocoding
    private let geocodingController = GeocodingController() // Controller for geocoding
    @State private var selectedCity: String? = nil // Track the selected city
    
    init(cityName: Binding<String>, viewModel: AutocompleteViewModel) {
        self._cityName = cityName
        self.viewModel = viewModel
        self.controller = SearchBarController(viewModel: viewModel)
    }

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Enter City Name", text: $cityName)
                    .onChange(of: cityName) { newValue in
                        if selectedCity != newValue { // Avoid triggering if user typed after selecting
                            controller.onTextChanged(newValue)
                        }
                    }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .background(Color(red: 0.95, green: 0.95, blue: 0.95)) // Light Grey
            .cornerRadius(8)
            .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
            
            if !viewModel.suggestions.isEmpty {
                List(viewModel.suggestions, id: \.id) { suggestion in
                    Button(action: {
                        selectCity(suggestion: suggestion)
                    }) {
                        Text("\(suggestion.city), \(suggestion.state)")
                            .foregroundColor(.primary)
                    }
                }
                .frame(maxHeight: 200) // Limit height of suggestion list
                .background(Color.white)
                .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
            }
        }
    }

    // Handle city selection
    private func selectCity(suggestion: AutocompleteSuggestion) {
        selectedCity = "\(suggestion.city), \(suggestion.state)" // Update the selected city
        cityName = selectedCity ?? cityName // Update cityName with selected city
        fetchCoordinates(for: cityName) // Fetch coordinates and update weather data
    }

    // Fetch coordinates and trigger weather data fetch
    private func fetchCoordinates(for city: String) {
        geocodingController.fetchCoordinates(for: city) { result in
            switch result {
            case .success(let coordinates):
                NotificationCenter.default.post(name: .cityCoordinatesUpdated, object: coordinates)
            case .failure(let error):
                print("Geocoding Error: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    struct SearchBarView_Preview: View {
        @State private var cityName: String = ""
        @ObservedObject var viewModel = AutocompleteViewModel()
        
        var body: some View {
            SearchBarView(cityName: $cityName, viewModel: viewModel)
        }
    }
    return SearchBarView_Preview()
}
