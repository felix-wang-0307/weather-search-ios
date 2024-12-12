import Highcharts
import UIKit

class WeeklyChartViewController: UIViewController {
    var weeklyWeather: [WeatherData] = [] // Assign from outside or after fetching
    private var chartView: HIChartView!

    override func viewDidLoad() {
        super.viewDidLoad()

        chartView = HIChartView(frame: view.bounds)
        view.addSubview(chartView)

        setupChart()
        updateChartData()
    }

    private func setupChart() {
        let options = HIOptions()

        let chart = HIChart()
        chart.type = "arearange"
        chart.zoomType = "x"
        chart.scrollablePlotArea = HIScrollablePlotArea()
        chart.scrollablePlotArea.minWidth = 600
        chart.scrollablePlotArea.scrollPositionX = 1
        options.chart = chart

        let title = HITitle()
        title.text = "Temperature Variation by Day"
        options.title = title

        let xAxis = HIXAxis()
        xAxis.type = "datetime"
        xAxis.accessibility = HIAccessibility()
        xAxis.accessibility.rangeDescription = "Next few days"
        options.xAxis = [xAxis]

        let yAxis = HIYAxis()
        yAxis.title = HITitle()
        yAxis.title.text = "Temperature (°F)"
        options.yAxis = [yAxis]

        let tooltip = HITooltip()
        tooltip.shared = true
        tooltip.valueSuffix = "°F" // Fahrenheit
        tooltip.xDateFormat = "%A, %b %e"
        options.tooltip = tooltip

        let legend = HILegend()
        legend.enabled = false
        options.legend = legend

        let temperatures = HIArearange()
        temperatures.name = "Temperatures"
        // Initially empty, will fill after data is processed
        temperatures.data = []

        options.series = [temperatures]

        chartView.options = options
    }

    func updateChartData() {
        guard !weeklyWeather.isEmpty else {
            print("No weekly weather data")
            return
        }

        let data = weeklyWeather.compactMap { day -> [Any]? in
            guard let dateString = day.date,
                  let highStr = day.temperatureHigh?.replacingOccurrences(of: "°F", with: ""),
                  let lowStr = day.temperatureLow?.replacingOccurrences(of: "°F", with: ""),
                  let high = Double(highStr),
                  let low = Double(lowStr) else {
                return nil
            }
            let formatter = ISO8601DateFormatter()
            guard let date = formatter.date(from: dateString) else {
                print("Date parse failed for \(dateString)")
                return nil
            }
            let timestamp = date.timeIntervalSince1970 * 1000
            return [timestamp, low, high]
        }

        print("Data points: \(data)") // Check that this prints a non-empty array

        if let options = chartView.options, let temps = options.series.first as? HIArearange {
            temps.data = data
            chartView.reload()
        }
    }

}
