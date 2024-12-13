import SwiftUI
import Alamofire
import SwiftyJSON
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weeklyWeather: [WeatherData] = [] // Weekly weather data
    @Published var currentWeather: WeatherData? // Current weather data
    @Published var cityName: String = "Unknown" // Current city name

    private var baseUrl: String = "https://weather-search-web-571.wn.r.appspot.com" // API base URL
    
    init() {
        if cityName == "Unknown" {
            let locationManager = LocationManager()
            let latitude = locationManager.latitude
            let longitude = locationManager.longitude
            cityName = locationManager.cityName
            fetchWeather(latitude: latitude, longitude: longitude)
        }
    }

    /// Fetch weather data based on latitude and longitude
    func fetchWeather(latitude: Double, longitude: Double) {
        debugPrint("Fetching weather data for \(latitude), \(longitude)")
        let url = "\(baseUrl)/weather"
        
        AF.request(url, parameters: ["latitude": latitude, "longitude": longitude]).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseWeatherData(json: json)
            case .failure(let error):
                print("Error fetching weather data: \(error.localizedDescription)")
            }
        }
    }
    
    /// Parse the JSON response and update `weeklyWeather` and `currentWeather`
    private func parseWeatherData(json: JSON) {
        guard let weeklyWeather = json["data"]["timelines"][0]["intervals"].array else {
            print("Error parsing weather data: No intervals found")
            return
        }
        
        // Parse weekly weather
        var weatherList: [WeatherData] = []
        for interval in weeklyWeather {
            let weather = parseInterval(interval: interval)
            weatherList.append(weather)
        }
        
        // Parse current weather
        let currentWeatherJSON = json["data"]["timelines"][2]["intervals"][0]
        let currentWeather = parseInterval(interval: currentWeatherJSON)
        
        debugPrint(json["data"]["city"].stringValue)
        DispatchQueue.main.async {
            self.weeklyWeather = weatherList
            self.currentWeather = currentWeather
            self.cityName = json["data"]["city"].stringValue
        }
    }
    
    /// Parse individual weather intervals
    private func parseInterval(interval: JSON) -> WeatherData {
        let values = interval["values"]
        return WeatherData(
            date: interval["startTime"].string,
            weatherCode: values["weatherCode"].int.flatMap { String($0) },  // Treat as string
            sunriseTime: values["sunriseTime"].string,
            sunsetTime: values["sunsetTime"].string,
            humidity: values["humidity"].double.flatMap { formatToTwoDecimals($0) + "%" },
            temperatureHigh: values["temperatureMax"].double.flatMap { formatToTwoDecimals($0) + "°F" },
            temperatureLow: values["temperatureMin"].double.flatMap { formatToTwoDecimals($0) + "°F" },
            visibility: values["visibility"].double.flatMap { formatToTwoDecimals($0) + " mi" },
            windSpeed: values["windSpeed"].double.flatMap { formatToTwoDecimals($0) + " mph" },
            pressureSeaLevel: values["pressureSeaLevel"].double.flatMap { formatToTwoDecimals($0) + " inHg" },
            cloudCover: values["cloudCover"].double.flatMap { formatToTwoDecimals($0) + "%" },
            uvIndex: values["uvIndex"].int.flatMap { String($0) },
            precipitation: values["precipitationProbability"].double.flatMap { formatToTwoDecimals($0) + "%" }
        )
    }
    
    /// Format a Double to two decimal places as a String
    private func formatToTwoDecimals(_ value: Double) -> String {
        String(format: "%.2f", value)
    }
}
