import SwiftUI
import SwiftSpinner

struct CityDetailView: View {
    let cityName: String
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = WeatherViewModel() // Assume this fetches weather data
    
    var body: some View {
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
                        .padding(.horizontal, 15)
                    
                    // Weekly Forecast
                    WeeklyWeatherView(viewModel: viewModel)
                        .padding(.horizontal, 15)
                }
                .padding(.top, 20)
                
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
            
            // Trailing ToolbarItem: "X" icon for tweet
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    postTweet()
                }) {
                    Image("twitter")
                }
            }
        }
        .onAppear {
            // SwiftSpinner.show("Fetching Weather Details for \(cityName)")
            fetchWeatherForCity(cityName)
        }
        .onChange(of: viewModel.currentWeather) { _ in
            SwiftSpinner.hide()
        }
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
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
    
    private func postTweet() {
        guard let weather = viewModel.currentWeather else {
            return
        }
        
        // Construct a status message from the weather data
        // Adjust the properties based on your WeatherData structure:
        let temperature = weather.temperatureHigh ?? "--°F"
        let conditions = weather.weatherCode ?? "Unknown Conditions"
        let tweetText = "The current weather in \(cityName) is \(temperature) and \(conditions)"
        
        // Encode for URL
        guard let encodedText = tweetText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        let tweetURLString = "https://twitter.com/intent/tweet?text=\(encodedText)"
        if let url = URL(string: tweetURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    // Presenting CityDetailView inside a NavigationView at preview time
    NavigationView {
        CityDetailView(cityName: "San Francisco")
    }
    .onAppear {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
