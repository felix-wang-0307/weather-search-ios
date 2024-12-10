//
//  ContentView.swift
//  WeatherSearchIOS
//
//  Created by Waterdog on 2024/12/9.
//

import SwiftUI

import Alamofire


struct ContentView: View {
    @State var cityName: String = ""
    var body: some View {
        VStack {
            SearchBar(cityName: $cityName)
        }
    }
}

#Preview {
    struct ContentViewPreviews: View {
        @State var cityName: String = "Los Angeles"
        var body: some View {
            ContentView(cityName: cityName)
        }
    }
    return ContentViewPreviews()
}
