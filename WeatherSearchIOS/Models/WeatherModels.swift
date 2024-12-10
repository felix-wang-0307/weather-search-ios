import Foundation

struct WeatherData {
    var currentTemperature: Double
    var currentHumidity: Double
    var currentWindSpeed: Double
    var forecasts: [DailyForecast]
}

struct DailyForecast: Identifiable {
    var id = UUID()
    var day: String
    var minTemp: Double
    var maxTemp: Double
    var icon: String
}
