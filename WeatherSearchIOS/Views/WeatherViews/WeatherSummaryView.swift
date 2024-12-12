import SwiftUI

struct WeatherSummaryView: View {
    @ObservedObject var viewModel: WeatherViewModel // Bind to the ViewModel
    
    var body: some View {
        ViewThatFits {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.3))
                    .overlay( // Add the border
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white, lineWidth: 1) // White border with 2pt thickness
                    )
                
                HStack {
                    Image(viewModel.currentWeather?.getWeatherDesc() ?? "Cloudy") // Dynamic weather image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text(viewModel.currentWeather?.temperatureHigh ?? "--°F") // High temperature
                            .font(.system(size: 24, weight: .bold))
                        
                        Text(viewModel.currentWeather?.getWeatherDesc() ?? "Cloudy") // Date
                            
                        Text(viewModel.cityName) // City
                            .font(.title2)
                            .bold()
                    }
                    .padding()
                }
            }
            .frame(height: 200)
        }
    }
}

#Preview {
    struct WeatherSummary_Preview: View {
        var body: some View {
            
            ZStack {
                // Simulated data for preview
                let mockViewModel: WeatherViewModel = {
                    let viewModel = WeatherViewModel()
                    viewModel.currentWeather = WeatherData(
                        date: "2024-12-10T12:00:00",
                        weatherCode: "cloud.sun",
                        sunriseTime: "6:30 AM",
                        sunsetTime: "5:45 PM",
                        humidity: "75%",
                        temperatureHigh: "55°F",
                        temperatureLow: "40°F",
                        visibility: "10 mi",
                        windSpeed: "12 mph"
                    )
                    return viewModel
                }()
                
                WeatherSummaryView(
                    viewModel: mockViewModel
                )
            }
            .background(Color.teal)
        }
    }
    return WeatherSummary_Preview()
}


