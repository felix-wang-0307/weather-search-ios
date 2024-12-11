//
//  WeatherView.swift
//  WeatherSearchIOS
//
//  Created by Waterdog on 2024/12/9.
//

import SwiftUI

struct WeatherView: View {
    @State private var cityName: String = "Los Angeles"  // Simulate the binding with @State
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("App_background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all) // Ensure background covers the screen
            VStack(spacing: 20) { // Add spacing for better layout
                SearchBarView(cityName: $cityName)
                    .frame(maxWidth: .infinity)
                    
                
                WeatherSummaryView()
                    .frame(maxWidth: .infinity) // Constrain to screen width
                    .padding(.horizontal)
                    
                WeatherDetailsView()
                    .frame(maxWidth: .infinity) // Constrain to screen width
        
            }
            .padding() // Add overall padding for spacing
        }
        
    }
}

#Preview {
    WeatherView()
}
