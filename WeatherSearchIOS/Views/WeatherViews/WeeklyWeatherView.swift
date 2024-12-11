import SwiftUI

struct WeeklyWeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel // Dynamic data from ViewModel
    
    var body: some View {
        ZStack(alignment: .top) { // Scrollable view
            LazyVStack { // Vertically stacked rows
                ForEach(viewModel.weeklyWeather) { weather in
                    HStack(alignment: .center) {
                        Text(weather.getFormattedDate() )
                            .frame(width: 90)
                        Image(systemName: weather.weatherCode ?? "cloud")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text(weather.getSunriseTime() )
                            .frame(width: 70)
                        Image("sun-rise") // Sunrise icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text(weather.getSunsetTime() )
                            .frame(width: 70)
                        Image("sun-set") // Sunset icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    .padding(.horizontal, 20)
                    
                    // Add divider between rows, except for the last row
                    if weather != viewModel.weeklyWeather.last {
                        Divider()
                            .background(Color.white.opacity(0.8))
                            .padding(.horizontal, 20)
                    }
                }
            }
            .background(Color.white.opacity(0.8)) // Add background color for clarity
            .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2) // Add shadow
            .cornerRadius(8)
        }
        .onAppear {
            viewModel.fetchWeather(latitude: 40.71, longitude: -74.01) // Example: New York City coordinates
        }
    }
}

#Preview {
    struct WeeklyWeather_Preview: View {
        var body: some View {
            ZStack(alignment: .top) {
                Image("App_background")
                    .resizable()
                    .scaledToFill()
                
                WeeklyWeatherView(
                    viewModel: WeatherViewModel() // Provide a mock ViewModel for the preview
                )
                .onAppear {
                    // Inject mock data for the preview
                    let mockData = [
                        WeatherData(date: "2024-12-25", weatherCode: "cloud.sun", sunriseTime: "6:30 AM", sunsetTime: "5:45 PM"),
                        WeatherData(date: "11/16/2024", weatherCode: "cloud", sunriseTime: "6:31 AM", sunsetTime: "5:44 PM"),
                        WeatherData(date: "11/17/2024", weatherCode: "sun.max", sunriseTime: "6:32 AM", sunsetTime: "5:43 PM"),
                        WeatherData(date: "11/18/2024", weatherCode: "cloud.rain", sunriseTime: "6:33 AM", sunsetTime: "5:42 PM"),
                        WeatherData(date: "11/19/2024", weatherCode: "wind", sunriseTime: "6:34 AM", sunsetTime: "5:41 PM"),
                        WeatherData(date: "11/20/2024", weatherCode: "moon.stars", sunriseTime: "6:35 AM", sunsetTime: "5:40 PM"),
                        WeatherData(date: "11/21/2024", weatherCode: "moon.stars", sunriseTime: "6:35 AM", sunsetTime: "5:40 PM")
                    ]
                    WeeklyWeatherView(viewModel: WeatherViewModel())
                        .viewModel.weeklyWeather = mockData
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
            }
        }
    }
    return WeeklyWeather_Preview()
}
