import SwiftUI
import Alamofire
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weeklyWeather: [DailyWeather] = [] // Array to store fetched weather data
    @Published var currentWeather: CurrentWeather? // Variable to store current weather data
    
    func fetchWeeklyWeather() {
        
    }
}
