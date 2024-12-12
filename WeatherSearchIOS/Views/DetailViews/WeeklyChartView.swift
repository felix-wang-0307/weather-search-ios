import SwiftUI
import Highcharts

struct WeeklyChartView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: WeatherViewModel = WeatherViewModel()

    func makeUIViewController(context: Context) -> WeeklyChartViewController {
        let vc = WeeklyChartViewController()
        vc.weeklyWeather = viewModel.weeklyWeather
        return vc
    }

    func updateUIViewController(_ uiViewController: WeeklyChartViewController, context: Context) {
        // When viewModel.weeklyWeather updates, update the chart data
        uiViewController.weeklyWeather = viewModel.weeklyWeather
        uiViewController.updateChartData()
    }
}

#Preview {
    WeeklyChartView()
}
