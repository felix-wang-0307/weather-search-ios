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
        ViewThatFits {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.3))
                    .overlay( // Add the border
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white, lineWidth: 1) // White border with 2pt thickness
                    )
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
        }
    }
}

#Preview {
    struct WeatherSummary_Preview: View {
        var body: some View {
            ZStack {
                WeatherSummaryView()
            }.background(Color.teal)
        }
    }
    return WeatherSummary_Preview()
}
