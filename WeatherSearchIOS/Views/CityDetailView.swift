import SwiftUI
import SwiftSpinner

struct CityDetailView: View {
    let cityName: String
    @Environment(\.presentationMode) var presentationMode // For dismissing this view
    @StateObject private var viewModel = WeatherViewModel() // Assume WeatherViewModel fetches weather

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Image("App_background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Display City Weather Summary
                        WeatherSummaryView(viewModel: viewModel)
                            .padding(.horizontal, 15)
                        
                        // Weather Details
                        WeatherDetailsView(viewModel: viewModel)
                            .padding(.horizontal, 10)
                        
                        // Weekly Forecast
                        WeeklyWeatherView(viewModel: viewModel)
                            .padding(.horizontal, 15)
                    }
                    .padding()
                }
            }
            .navigationTitle(cityName) // Center title
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true) // Hide the default back button
            .toolbar {
                // Leading ToolbarItem: Custom back button with "Weather"
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 2) {
                            Image(systemName: "chevron.left")
                            Text("Weather")
                        }
                    }
                }
                
                // Trailing ToolbarItem: "X" icon
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action for posting a tweet (e.g., show a sheet)
                        print("X tapped - Post a tweet or other action.")
                    }) {
                        Image("t")
                    }
                }
            }
            .onAppear {
                //            SwiftSpinner.show("Fetching Weather Details for \(cityName)")
                fetchWeatherForCity(cityName)
            }
            .onChange(of: viewModel.currentWeather) { _ in
                SwiftSpinner.hide()
            }
        }
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            
            // Apply appearance
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    private func fetchWeatherForCity(_ city: String) {
        GeocodingController().fetchCoordinates(for: city) { result in
            switch result {
            case .success(let coordinates):
                viewModel.fetchWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                viewModel.cityName = city
            case .failure(let error):
                SwiftSpinner.hide()
                print("Error fetching coordinates: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    CityDetailView(cityName: "San Francisco")
}
