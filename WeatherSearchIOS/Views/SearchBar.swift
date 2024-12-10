//
//  SearchBar.swift
//  WeatherSearchIOS
//
//  Created by Waterdog on 2024/12/9.
//

import SwiftUI

struct SearchBar: View {
    @Binding var cityName: String  // Use @Binding to receive the city name from a parent view

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Enter City Name", text: $cityName)
        }
        .padding(.vertical, 10) // Adjust top and bottom padding (smaller value)
        .padding(.horizontal, 10) // Add more padding on the sides
        .background(
            Color(red: 0.95, green: 0.95, blue: 0.95) // Light Grey
        )
        .cornerRadius(8)
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)

    }
}


#Preview {
    struct SearchBarPreviewWrapper: View {
        @State private var cityName: String = "Los Angeles"  // Simulate the binding with @State

        var body: some View {
            SearchBar(cityName: $cityName)  // Bind the @State value
        }
    }

    return SearchBarPreviewWrapper()  // Return the wrapper view for the preview
}
