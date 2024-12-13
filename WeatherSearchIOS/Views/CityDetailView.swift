import SwiftUI
import Alamofire
import Toast
import SwiftyJSON

struct CityDetailView: View {
    let cityName: String
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = WeatherViewModel()
    @State private var isFavorite = false
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("App_background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .trailing, spacing: 20) {
                    // Favorite Button
                    Button(action: {
                        toggleFavorite()
                    }) {
                        Image(systemName: isFavorite ? "xmark" : "plus")
                            .foregroundColor(.black) // Button icon color
                            .padding(6)             // Add padding for circular shape
                            .background(Color.white) // White background
                            .clipShape(Circle())     // Round button
                            .shadow(radius: 5)       // Add subtle shadow
                            .padding(.trailing, 20)  // Align to the right
                    }
                    
                    // Weather Summary
                    WeatherSummaryView(viewModel: viewModel)
                        .padding(.horizontal, 15)
                    
                    // Weather Details
                    WeatherDetailsView(viewModel: viewModel)
                        .padding(.horizontal, 15)
                        .padding(.trailing, 20)
                }
                .padding(.top, 20)
                
            }
        }
        .navigationTitle(cityName) // Center title
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .toolbar {
            // Leading ToolbarItem: Custom back button with "Weather"
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.left")
                        Text("Weather")
                    }
                }
            }
            
            // Trailing ToolbarItem: "X" icon for tweet
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    postTweet()
                }) {
                    Image("twitter")
                }
            }
        }
        .onAppear {
            fetchWeatherForCity(cityName)
            checkIfFavorite()
        }
        .toast(isPresented: $showToast) {
            Text(toastMessage)
                .padding()
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 50)
        }
    }
    
    private func fetchWeatherForCity(_ city: String) {
        GeocodingController().fetchCoordinates(for: city) { result in
            switch result {
            case .success(let coordinates):
                viewModel.fetchWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                viewModel.cityName = city
            case .failure(let error):
                print("Error fetching coordinates: \(error.localizedDescription)")
            }
        }
    }
    
    private func postTweet() {
        guard let weather = viewModel.currentWeather else { return }
        
        let temperature = weather.temperatureHigh ?? "--°F"
        let conditions = weather.weatherCode ?? "Unknown Conditions"
        let tweetText = "The current weather in \(cityName) on \(weather.getFormattedDate()) is \(temperature). The weather conditions are \(conditions) #CSCI571WeatherSearch"
        
        guard let encodedText = tweetText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let tweetURLString = "https://twitter.com/intent/tweet?text=\(encodedText)"
        
        if let url = URL(string: tweetURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func toggleFavorite() {
        if isFavorite {
            removeFromFavorites()
        } else {
            addToFavorites()
        }
    }
    
    private func addToFavorites() {
        let parameters: [String: Any] = ["city": cityName, "state": "State", "user": "testUser"]
        let url = "https://weather-search-web-571.wn.r.appspot.com/favorites"
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success:
                DispatchQueue.main.async {
                    isFavorite = true
                    toastMessage = "\(cityName) added to the Favorites List"
                    showToast = true
                }
            case .failure(let error):
                print("Error adding to favorites: \(error.localizedDescription)")
            }
        }
    }
    
    private func removeFromFavorites() {
        let url = "https://weather-search-web-571.wn.r.appspot.com/favorites"
        let parameters: [String: Any] = ["city": cityName, "state": "State", "user": "testUser"]
        AF.request(url, method: .delete, parameters: parameters ).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                debugPrint(json)
                DispatchQueue.main.async {
                    isFavorite = false
                    toastMessage = "\(cityName) was removed from the Favorites List"
                    showToast = true
                }
            case .failure(let error):
                print("Error fetching favorites: \(error.localizedDescription)")
            }
        }
    }
    
    private func checkIfFavorite() {
        let url = "https://weather-search-web-571.wn.r.appspot.com/favorites?user=testUser"
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)["data"]
                let favorites = json.arrayValue
                if favorites.contains(where: { $0["city"].stringValue == cityName }) {
                    DispatchQueue.main.async {
                        isFavorite = true
                    }
                }
            case .failure(let error):
                print("Error checking favorite: \(error.localizedDescription)")
            }
        }
    }
}


extension View {
    func toast<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                content()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isPresented.wrappedValue = false
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    // Presenting CityDetailView inside a NavigationView at preview time
    NavigationView {
        CityDetailView(cityName: "San Francisco")
    }
    .onAppear {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
