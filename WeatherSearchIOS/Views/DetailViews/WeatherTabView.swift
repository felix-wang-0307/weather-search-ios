import SwiftUI
import SwiftSpinner

struct WeatherTabView: View {
    let cityName: String
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = WeatherViewModel()
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            Image("App_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.container, edges: .all) // Extend background fully

            TabView(selection: $selectedTab) {
                TodayWeatherFieldsView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("TODAY")
                    }
                    .tag(0)

                WeeklyChartContainer(viewModel: viewModel)
                    .padding(.horizontal, 15)
                    .tabItem {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("WEEKLY")
                    }
                    .tag(1)

                GaugeChartContainerView(viewModel: viewModel)
                    .padding(.horizontal, 15)
                    .tabItem {
                        Image(systemName: "cloud")
                        Text("WEATHER DATA")
                    }
                    .tag(2)
            }
        }
        .navigationTitle(cityName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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

            // Trailing ToolbarItem: Twitter icon
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    postTweet()
                }) {
                    Image("twitter")
                }
            }
        }
        .toolbarBackground(Color.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            fetchWeatherForCity(cityName)
        }
        .onChange(of: viewModel.currentWeather) { _ in
            SwiftSpinner.hide()
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
        let temperature = weather.temperatureHigh ?? "--°F"
        let conditions = weather.weatherCode ?? "Unknown Conditions"
        // Tweet Content Example:
          // The temperature in Los Angeles, California on Thursday, Oct. 10, 2024 is 75°F.
          // The weather conditions are Clear #CSCI571WeatherSearch
        let tweetText = "The current weather in \(cityName) on \(weather.getFormattedDate()) is \(temperature). The weather conditions are \(conditions) #CSCI571WeatherSearch"
        
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
    NavigationView {
        WeatherTabView(cityName: "Los Angeles")
    }
}
