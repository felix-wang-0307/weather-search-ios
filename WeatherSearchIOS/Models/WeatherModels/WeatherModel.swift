//
//  WeeklyWeatherModel.swift
//  WeatherSearchIOS
//
//  Created by Waterdog on 2024/12/10.
//

import SwiftUI

struct DailyWeather: Identifiable, Equatable {
    let id = UUID() // Unique identifier for each row
    let date: String  // The ISO 8601 date
    let weatherIcon: String
    let sunriseTime: String
    let sunsetTime: String
    let humidity: String
    let temperatureHigh: String
    let temperatureLow: String
    let visibility: String
    let windSpeed: String
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date!)
    }
}

