
//
//  WeeklyWeatherModel.swift
//  WeatherSearchIOS
//
//  Created by Waterdog on 2024/12/10.
//

import Foundation

struct WeatherData: Identifiable, Equatable {
    let id = UUID() // Unique identifier for each row
    let date: String?  // The ISO 8601 date
    let weatherCode: String? // Weather icon name
    let sunriseTime: String? // Sunrise time
    let sunsetTime: String? // Sunset time
    let humidity: String? // Humidity value
    let temperatureHigh: String? // High temperature
    let temperatureLow: String? // Low temperature
    let visibility: String? // Visibility value
    let windSpeed: String? // Wind speed
    let pressureSeaLevel: String? // Sea level
    let cloudCover: String? // Cloud cover
    let uvIndex: String? // UV index
    let precipitation: String? // Precipitation
    
    init(
        date: String? = nil,
        weatherCode: String? = nil,
        sunriseTime: String? = nil,
        sunsetTime: String? = nil,
        humidity: String? = nil,
        temperatureHigh: String? = nil,
        temperatureLow: String? = nil,
        visibility: String? = nil,
        windSpeed: String? = nil,
        pressureSeaLevel: String? = nil,
        cloudCover: String? = nil,
        uvIndex: String? = nil,
        precipitation: String? = nil
    ) {
        self.date = date
        self.weatherCode = weatherCode
        self.sunriseTime = sunriseTime
        self.sunsetTime = sunsetTime
        self.humidity = humidity
        self.temperatureHigh = temperatureHigh
        self.temperatureLow = temperatureLow
        self.visibility = visibility
        self.windSpeed = windSpeed
        self.pressureSeaLevel = pressureSeaLevel
        self.cloudCover = cloudCover
        self.uvIndex = uvIndex
        self.precipitation = precipitation
    }
    
    func getWeatherDesc() -> String {
        debugPrint(weatherCode ?? "1000")
        let mapper = WeatherCodeMapper()
        return mapper.descriptionForCode(weatherCode ?? "1000")
    }
    
    /// Formats the ISO date into a MM/dd/yyyy format.
    func getFormattedDate() -> String {
        guard let date = date else { return "Unknown" } // Handle missing date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // ISO 8601 format
        if let parsedDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.string(from: parsedDate)
        }
        return "Invalid Date"
    }
    
    /// Convert the ISO 8601 time to a 12-hour format (e.g., 6:30 AM).
    private func getTimeFrom(date: String) -> String {
        let isoFormatter = ISO8601DateFormatter() // Use ISO8601DateFormatter for parsing
//        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // Handle fractional seconds if present
        
        if let parsedDate = isoFormatter.date(from: date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a" // 12-hour format with AM/PM
            return dateFormatter.string(from: parsedDate)
        }
        return "Invalid Time"
    }

    
    func getSunriseTime() -> String {
        guard let sunriseTime = sunriseTime else { return "Unknown" } // Handle missing time
        return getTimeFrom(date: sunriseTime)
    }
    
    func getSunsetTime() -> String {
        guard let sunsetTime = sunsetTime else { return "Unknown" } // Handle missing time
        return getTimeFrom(date: sunsetTime)
    }
}


