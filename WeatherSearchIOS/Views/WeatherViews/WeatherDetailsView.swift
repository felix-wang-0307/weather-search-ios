import SwiftUI

struct WeatherDetailsView: View {
    
    @ObservedObject var viewModel: WeatherViewModel // Bind to the ViewModel
    
    /// Dynamically create details array based on currentWeather
    private func getDetails() -> [(title: String, icon: String, value: String)] {
        guard let currentWeather = viewModel.currentWeather else {
            return [
                ("Humidity", "Humidity", "-- %"),
                ("Wind Speed", "WindSpeed", "-- mph"),
                ("Visibility", "Visibility", "-- mi"),
                ("Pressure", "Pressure", "-- inHg")
            ]
        }
        
        return [
            ("Humidity", "Humidity", currentWeather.humidity ?? "-- %"),
            ("Wind Speed", "WindSpeed", currentWeather.windSpeed ?? "-- mph"),
            ("Visibility", "Visibility", currentWeather.visibility ?? "-- mi"),
            ("Pressure", "Pressure", currentWeather.pressureSeaLevel ?? "-- inHg")
        ]
    }
    
    var body: some View {
        ViewThatFits(in: .horizontal, content: {
            HStack {
                // Dynamically create details based on currentWeather
                ForEach(getDetails(), id: \.title) { detail in
                    VStack(spacing: 20) {
                        Text(detail.title) // Display the title (e.g., "Humidity")
                        Image(detail.icon) // Display the corresponding SF Symbol
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        Text(detail.value) // Display the value
                    }
                    .padding(.horizontal, 2)
                }
            }
        })
    }
}

#Preview {
    struct WeatherDetails_Preview: View {
        var body: some View {
            // Provide a mock ViewModel for testing
            let mockViewModel = WeatherViewModel()
            mockViewModel.currentWeather = WeatherData(
                date: "2024-12-10",
                weatherCode: "1000",
                sunriseTime: "6:30 AM",
                sunsetTime: "5:45 PM",
                humidity: "75%",
                temperatureHigh: "55°F",
                temperatureLow: "40°F",
                visibility: "10 mi",
                windSpeed: "12 mph",
                pressureSeaLevel: "30.08 inHg"
            )
            return WeatherDetailsView(viewModel: mockViewModel)
        }
    }
    return WeatherDetails_Preview()
}
