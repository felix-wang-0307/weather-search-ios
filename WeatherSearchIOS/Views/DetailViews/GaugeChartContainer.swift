import SwiftUI

struct GaugeChartContainerView: View {
    @ObservedObject var viewModel: WeatherViewModel = WeatherViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .shadow(radius: 4)
                    
                    VStack(spacing: 16) {
                        HStack {
                            Image("Precipitation")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Spacer()
                            Text("Precipitation: \(viewModel.currentWeather?.precipitation ?? "--")")
                        }
                        .padding(.horizontal, 50)

                        HStack {
                            Image(systemName: "humidity.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Spacer()
                            Text("Humidity: \(viewModel.currentWeather?.humidity ?? "--")")
                        }
                        .padding(.horizontal, 50)

                        HStack {
                            Image(systemName: "cloud.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Spacer()
                            Text("Cloud Cover: \(viewModel.currentWeather?.cloudCover ?? "--")")
                        }
                        .padding(.horizontal, 50)
                    }
                }
                .frame(height: 200)

                // Add the GaugeChartView below
                GaugeChartView(viewModel: viewModel)
                    .frame(height: 600)
            }
        }
        .background(
            Image("App_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    GaugeChartContainerView()
}
