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
                    TodayFieldView(icon: "wind", value: viewModel.currentWeather?.windSpeed ?? "-- mph", label: "Wind Speed")
                    TodayFieldView(icon: "gauge", value: viewModel.currentWeather?.pressureSeaLevel ?? "-- inHG", label: "Pressure")
                    TodayFieldView(icon: "cloud.rain", value: viewModel.currentWeather?.precipitation ?? "--%", label: "Precipitation")
                    
                    TodayFieldView(icon: "thermometer", value: viewModel.currentWeather?.temperatureHigh ?? "-- °F", label: "Temperature")
                    TodayFieldView(icon: "cloud", value: viewModel.currentWeather?.getWeatherDesc() ?? "Cloudy", label: "Conditions")
                    TodayFieldView(icon: "humidity", value: viewModel.currentWeather?.humidity ?? "--%", label: "Humidity")
                    
                    TodayFieldView(icon: "eye", value: viewModel.currentWeather?.visibility ?? "-- mi", label: "Visibility")
                    TodayFieldView(icon: "cloud.fill", value: viewModel.currentWeather?.cloudCover ?? "--%", label: "Cloud Cover")
                    TodayFieldView(icon: "sun.max", value: viewModel.currentWeather?.uvIndex ?? "--", label: "UVIndex")
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
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(height: 80)
            Text(value)
            Text(label)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(8)
    }
}



