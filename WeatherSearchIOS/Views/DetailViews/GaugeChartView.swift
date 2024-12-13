import SwiftUI

struct GaugeChartView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: WeatherViewModel

    func makeUIViewController(context: Context) -> GaugeChartViewController {
        let controller = GaugeChartViewController()
        controller.currentWeather = viewModel.currentWeather // Pass dynamic data
        return controller
    }

    func updateUIViewController(_ uiViewController: GaugeChartViewController, context: Context) {
        uiViewController.currentWeather = viewModel.currentWeather
        uiViewController.updateChartData() // Update the chart when data changes
    }
}
