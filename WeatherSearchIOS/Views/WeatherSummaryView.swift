//
//  WeatherSummaryView.swift
//  WeatherSearchIOS
//
//  Created by Waterdog on 2024/12/9.
//

import SwiftUI

struct WeatherSummaryView: View {
    @State var temperature: String = "80°F"
    @State var condition: String = "Clear"
    @State var cityName: String = "Los Angeles"
    @State var weatherImage: String = "Clear" 
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(radius: 5)
            HStack {
                Image(weatherImage) // Replace with dynamic image if available
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                VStack(alignment: .leading, spacing: 20) {
                    Text("80°F")
                        .font(.system(size: 24, weight: .bold))
                    Text("Cloudy")
                        
                    
                    Text("Los Angeles")
                        .font(.title2)
                        .bold()
                }
                .padding()
            }
        }
        .frame(height: 200)
        .padding()
    }
}

#Preview {
    WeatherSummaryView()
}
