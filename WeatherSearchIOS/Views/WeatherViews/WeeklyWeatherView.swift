//
//  WeeklyWeatherView.swift
//  WeatherSearchIOS
//
//  Created by Waterdog on 2024/12/10.
//

import SwiftUI

struct WeeklyWeatherView: View {
    // Sample data for the week
    let weeklyWeather = [
        DailyWeather(date: "12/25/2024", weatherIcon: "Cloudy", sunriseTime: "6:30 AM", sunsetTime: "5:45 PM"),
        DailyWeather(date: "11/16/2024", weatherIcon: "Cloudy", sunriseTime: "6:31 AM", sunsetTime: "5:44 PM"),
        DailyWeather(date: "11/17/2024", weatherIcon: "Clear", sunriseTime: "6:32 AM", sunsetTime: "5:43 PM"),
        DailyWeather(date: "11/18/2024", weatherIcon: "Light Rain", sunriseTime: "6:33 AM", sunsetTime: "5:42 PM"),
        DailyWeather(date: "11/19/2024", weatherIcon: "Light Wind", sunriseTime: "6:34 AM", sunsetTime: "5:41 PM"),
        DailyWeather(date: "11/20/2024", weatherIcon: "Mostly Clear", sunriseTime: "6:35 AM", sunsetTime: "5:40 PM"),
        DailyWeather(date: "11/21/2024", weatherIcon: "Mostly Clear", sunriseTime: "6:35 AM", sunsetTime: "5:40 PM")
    ]
    
    var body: some View {
        ZStack(alignment: .top) { // Scrollable view
            LazyVStack { // Vertically stacked rows
                ForEach(weeklyWeather) { weather in
                    HStack(alignment: .center) {
                        Text(weather.date) // Date
                            .frame(width: 90)
                        Image(weather.weatherIcon) // Weather icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text(weather.sunriseTime) // Sunrise time
                            .frame(width: 70)
                        Image("sun-rise") // Sunrise icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text(weather.sunsetTime) // Sunset time
                            .frame(width: 70)
                        Image("sun-set") // Sunset icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    .padding(.horizontal, 20)
                    
                    if weather != weeklyWeather.last { // Add divider between rows
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
    }
}

#Preview {
    struct WeeklyWeather_Preview: View {
        var body: some View {
            ZStack(alignment: .top) {
                Image("App_background")
                    .resizable()
                    .scaledToFill()
                WeeklyWeatherView()
                    .padding(.horizontal, 30)
                    .padding(.vertical, 20)
            }
        }
    }
    return WeeklyWeather_Preview()
}
