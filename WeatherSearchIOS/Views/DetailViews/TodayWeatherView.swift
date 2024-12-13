//
//  TodayWeatherView.swift
//  WeatherSearchIOS
//
//  Created by Waterdog on 2024/12/12.
//

import SwiftUI

struct TodayWeatherFieldsView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        // A full-screen grid of weather fields
        ScrollView {
            ZStack {
                Image("App_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.container, edges: .all) // Extend background fully
                LazyVGrid(columns: columns, spacing: 20) {
                    TodayFieldView(icon: "WindSpeed", value: viewModel.currentWeather?.windSpeed ?? "-- mph", label: "Wind Speed")
                    TodayFieldView(icon: "Pressure", value: viewModel.currentWeather?.pressureSeaLevel ?? "-- inHG", label: "Pressure")
                    TodayFieldView(icon: "Precipitation", value: viewModel.currentWeather?.precipitation ?? "--%", label: "Precipitation")
                    
                    TodayFieldView(icon: "Temperature", value: viewModel.currentWeather?.temperatureHigh ?? "-- °F", label: "Temperature")
                    TodayFieldView(icon: viewModel.currentWeather?.getWeatherDesc() ?? "Cloudy", value: viewModel.currentWeather?.getWeatherDesc() ?? "Cloudy", label: "Conditions")
                    TodayFieldView(icon: "Humidity", value: viewModel.currentWeather?.humidity ?? "--%", label: "Humidity")
                    
                    TodayFieldView(icon: "Visibility", value: viewModel.currentWeather?.visibility ?? "-- mi", label: "Visibility")
                    TodayFieldView(icon: "CloudCover", value: viewModel.currentWeather?.cloudCover ?? "--%", label: "Cloud Cover")
                    TodayFieldView(icon: "UVIndex", value: viewModel.currentWeather?.uvIndex ?? "--", label: "UVIndex")
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct TodayFieldView: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(height: 80)
            VStack {
                Text(value)
                if label != "Conditions" {
                    Text(label)
                        .font(.caption)
                }
            }
                .frame(height: 40)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(8)
    }
}



