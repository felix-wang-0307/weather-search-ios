//
//  WeeklyContainerView.swift
//  WeatherSearchIOS
//
//  Created by Waterdog on 2024/12/12.
//

import SwiftUI

struct WeeklyChartContainer: View {
    @ObservedObject var viewModel: WeatherViewModel = WeatherViewModel()

    var body: some View {
        ScrollView {
            ZStack {
                Image("App_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.container, edges: .all) // Extend background fully
                VStack {
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
                                
                                VStack(alignment: .center, spacing: 20) {
                                    
                                    
                                    Text(viewModel.currentWeather?.getWeatherDesc() ?? "Cloudy") // Date
                                        .font(.system(size: 24))
                                    
                                    Text(viewModel.currentWeather?.temperatureHigh ?? "--°F") // High temperature
                                        .font(.system(size: 36, weight: .bold))
                                }
                                .padding()
                            }
                        }
                        .frame(height: 300)
                        .padding()
                    }
                    
                    WeeklyChartView(viewModel: viewModel)
                        .padding(.bottom, 100)
                }
            }
        }
    }
}


#Preview {
    WeeklyChartContainer()
}
