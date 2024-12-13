import Highcharts
import UIKit

class GaugeChartViewController: UIViewController {
    var currentWeather: WeatherData? // Assign dynamically from ViewModel
    private var chartView: HIChartView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupChart()
        updateChartData() // Dynamically update the chart based on `currentWeather`
    }

    private func setupUI() {
        view.backgroundColor = .clear
        chartView = HIChartView(frame: .zero)
        chartView.plugins = ["solid-gauge"]
        chartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartView)

        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chartView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            chartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }

    private func setupChart() {
        let options = HIOptions()

        let chart = HIChart()
        chart.type = "solidgauge"
        chart.height = "110%"
        options.chart = chart

        let title = HITitle()
        title.text = "Weather Data"
        title.style = HICSSObject()
        title.style.fontSize = "24px"
        options.title = title

        let tooltip = HITooltip()
        tooltip.borderWidth = 0
        tooltip.shadow = HIShadowOptionsObject()
        tooltip.shadow.opacity = 0
        tooltip.style = HICSSObject()
        tooltip.style.fontSize = "16px"
        tooltip.valueSuffix = "%"
        tooltip.pointFormat = "{series.name}<br><span style=\"font-size:2em; color: {point.color}; font-weight: bold\">{point.y}</span>"
        tooltip.positioner = HIFunction(jsFunction: "function (labelWidth) { return { x: (this.chart.chartWidth - labelWidth) / 2, y: (this.chart.plotHeight / 2) + 15 }; }")
        options.tooltip = tooltip

        let pane = HIPane()
        pane.startAngle = 0
        pane.endAngle = 360

        let background1 = HIBackground()
        background1.backgroundColor = HIColor(rgba: 106, green: 165, blue: 231, alpha: 0.35)
        background1.outerRadius = "112%"
        background1.innerRadius = "88%"
        background1.borderWidth = 0

        let background2 = HIBackground()
        background2.backgroundColor = HIColor(rgba: 51, green: 52, blue: 56, alpha: 0.35)
        background2.outerRadius = "87%"
        background2.innerRadius = "63%"
        background2.borderWidth = 0

        let background3 = HIBackground()
        background3.backgroundColor = HIColor(rgba: 130, green: 238, blue: 106, alpha: 0.35)
        background3.outerRadius = "62%"
        background3.innerRadius = "38%"
        background3.borderWidth = 0

        pane.background = [background1, background2, background3]
        options.pane = pane

        let yAxis = HIYAxis()
        yAxis.min = 0
        yAxis.max = 100
        yAxis.lineWidth = 0
        yAxis.tickPosition = ""
        options.yAxis = [yAxis]

        let plotOptions = HIPlotOptions()
        plotOptions.solidgauge = HISolidgauge()
        let dataLabels = HIDataLabels()
        dataLabels.enabled = false
        plotOptions.solidgauge.dataLabels = [dataLabels]
        plotOptions.solidgauge.linecap = "round"
        plotOptions.solidgauge.stickyTracking = false
        plotOptions.solidgauge.rounded = true
        options.plotOptions = plotOptions

        chartView.options = options
    }

    func updateChartData() {
        guard let weather = currentWeather else { return }

        let precipitation = HISolidgauge()
        precipitation.name = "Precipitation"
        let precipitationData = HIData()
        precipitationData.color = HIColor(rgba: 106, green: 165, blue: 231, alpha: 1)
        precipitationData.radius = "112%"
        precipitationData.innerRadius = "88%"
        precipitationData.y = NSNumber(value: Double(weather.precipitation?.replacingOccurrences(of: "%", with: "") ?? "0") ?? 0)
        precipitation.data = [precipitationData]

        let humidity = HISolidgauge()
        humidity.name = "Humidity"
        let humidityData = HIData()
        humidityData.color = HIColor(rgba: 51, green: 52, blue: 56, alpha: 1)
        humidityData.radius = "87%"
        humidityData.innerRadius = "63%"
        humidityData.y = NSNumber(value: Double(weather.humidity?.replacingOccurrences(of: "%", with: "") ?? "0") ?? 0)
        humidity.data = [humidityData]

        let cloudCover = HISolidgauge()
        cloudCover.name = "Cloud Cover"
        let cloudCoverData = HIData()
        cloudCoverData.color = HIColor(rgba: 130, green: 238, blue: 106, alpha: 1)
        cloudCoverData.radius = "62%"
        cloudCoverData.innerRadius = "38%"
        cloudCoverData.y = NSNumber(value: Double(weather.cloudCover?.replacingOccurrences(of: "%", with: "") ?? "0") ?? 0)
        cloudCover.data = [cloudCoverData]

        chartView.options.series = [precipitation, humidity, cloudCover]
        chartView.reload() // Refresh the chart
    }
}
