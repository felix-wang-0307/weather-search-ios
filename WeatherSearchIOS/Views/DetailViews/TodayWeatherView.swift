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
            LazyVGrid(columns: columns, spacing: 20) {
                TodayFieldView(icon: "wind", value: viewModel.currentWeather?.windSpeed ?? "-- mph", label: "Wind Speed")
                TodayFieldView(icon: "gauge", value: viewModel.currentWeather?.pressureSeaLevel ?? "-- inHG", label: "Pressure")
                TodayFieldView(icon: "cloud.rain", value: "30 %", label: "Precipitation")

                TodayFieldView(icon: "thermometer", value: viewModel.currentWeather?.temperatureHigh ?? "-- °F", label: "Temperature")
                TodayFieldView(icon: "cloud", value: "Cloudy", label: "Conditions")
                TodayFieldView(icon: "humidity", value: viewModel.currentWeather?.humidity ?? "0 %", label: "Humidity")

                TodayFieldView(icon: "eye", value: viewModel.currentWeather?.visibility ?? "-- mi", label: "Visibility")
                TodayFieldView(icon: "cloud.fill", value: "100 %", label: "Cloud Cover")
                TodayFieldView(icon: "sun.max", value: "10", label: "UVIndex")
            }
            .padding()
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
                .frame(height: 40)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(8)
    }
}



