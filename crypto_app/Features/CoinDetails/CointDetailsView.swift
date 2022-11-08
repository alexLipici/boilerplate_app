////
////  CointDetailsView.swift
////  crypto_app
////
////  Created by Petru-Alexandru Lipici on 08.11.2022.
////
//
//import UIKit
//import SnapKit
//import Charts
//
//class CointDetailsView: UIView {
//
//    lazy var chartView = LineChartView(frame: .zero)
//    lazy var tableView: UITableView = {
//        UIBuilder.makeInsetGroupedTableView()
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        addSubviews()
//        configSubviewsConstraints()
//        configSubviewsLayout()
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//
//    private func addSubviews() {
//        addSubview(chartView)
//        addSubview(tableView)
//    }
//
//    private func configSubviewsConstraints() {
//        chartView.snp.makeConstraints { make in
//            make.top.leading.trailing.equalToSuperview().inset(16)
//        }
//
//        tableView.snp.makeConstraints { make in
//            make.top.equalTo(charView.snp.bottom)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
//    }
//
//    private func configSubviewsLayout() {
//        tableView.contentInset = .init(top: 12, left: 0, bottom: 0, right: 0)
//    }
//
//    func setLayout(evolutions: [CoinValueEvolution]) {
//
//        self.evolutions = evolutions
//
//        let evolutionsValues: [Double] = evolutions.map({ Double($0.value) ?? 0.0 })
//        maxValue = evolutionsValues.max() ?? 100.0
//        minValue = evolutionsValues.min() ?? 0.0
//
//        setAxis()
//
//        drawChart()
//    }
//
//    private func setAxis() {
//
//            // X axis setup
//        chartView.xAxis.valueFormatter = self
//        chartView.xAxis.drawAxisLineEnabled = false
//        chartView.xAxis.drawLabelsEnabled = true
//        chartView.xAxis.drawGridLinesEnabled = false
//        chartView.xAxis.labelPosition = .bottom
//        chartView.xAxis.granularityEnabled = true
//        chartView.xAxis.granularity = 1.0
//        chartView.xAxis.spaceMin = 0.2
//        chartView.xAxis.spaceMax = 0.2
//        chartView.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 11)
//        chartView.xAxis.yOffset = 20.0
//
//            // Y axis setup
//        chartView.leftAxis.gridColor = .gray
//        chartView.leftAxis.gridLineWidth = 1.0
//        chartView.leftAxis.drawZeroLineEnabled = true
//        chartView.leftAxis.drawLabelsEnabled = false
//        chartView.leftAxis.drawAxisLineEnabled = false
//        chartView.leftAxis.drawLimitLinesBehindDataEnabled = false
//        chartView.leftAxis.drawGridLinesEnabled = true
//
//        chartView.leftAxis.axisMaximum = Double(maxValue + (maxValue / 10.0))
//        chartView.leftAxis.axisMinimum = Double(minValue - (maxValue / 10.0))
//
//        chartView.rightAxis.gridColor = .gray
//        chartView.rightAxis.gridLineWidth = 0.0
//        chartView.rightAxis.drawLabelsEnabled = false
//        chartView.rightAxis.drawAxisLineEnabled = false
//
//            // chart setup
//        chartView.setScaleEnabled(false)
//        chartView.backgroundColor = .white
//        chartView.chartDescription.text = ""
//        chartView.legend.enabled = false
//        chartView.noDataText = "No data"
//        chartView.delegate = self
//    }
//
//    private func drawChart() {
//
//        var lineChartDataSet: LineChartDataSet
//        var dataSet: [ChartDataEntry] = []
//
//        for (index, evolution) in evolutions.enumerated() {
//
//            if let value = Double(evolution.value)?.round(to: 2) {
//
//                let chartBubbleImage: UIImage = evolution.hasNormalValues ?
//                UIImage(named: "chart_green_bubble")! :
//                UIImage(named: "chart_red_bubble")!
//
//                let chartValue = ChartDataEntry(x: Double(index),
//                                                y: value,
//                                                icon: chartBubbleImage,
//                                                data: evolution)
//                dataSet.append(chartValue)
//            }
//        }
//
//        lineChartDataSet = LineChartDataSet(entries: dataSet, label: .empty)
//        lineChartDataSet.circleColors = [.clear]
//        lineChartDataSet.lineWidth = 0.0
//        lineChartDataSet.drawValuesEnabled = false
//            //        lineChartDataSet.mode = .cubicBezier
//
//        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
//                                     colors: [UIColor.white, UIColor.gray.withAlphaComponent(0.6), UIColor.gray].map({ $0.cgColor }) as CFArray,
//                                     locations: [0.0, 0.3, 1.0]) {
//
//            lineChartDataSet.drawFilledEnabled = true
//            lineChartDataSet.fill = LinearGradientFill(gradient: gradient, angle: 90)
//        }
//
//        let lineChartData = LineChartData(dataSets: [lineChartDataSet])
//
//        chartView.data = lineChartData
//
//        if dataSet.count > chartMaxPointsOnPage {
//            chartView.setVisibleXRangeMaximum(Double(chartMaxPointsOnPage) - 0.5)
//        }
//
//            // scroll to the latest element
//        let lastIndex = dataSet.count - 1
//        if let lastEntry = lineChartData.dataSets.first?.entryForIndex(lastIndex) {
//            chartView.centerViewTo(xValue: lastEntry.x, yValue: lastEntry.y, axis: .right)
//        }
//    }
//}
//
//extension CointDetailsView: ChartViewDelegate, AxisValueFormatter {
//
//    internal func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//
//        guard Int(value) < evolutions.count else {
//            return ""
//        }
//
//        return evolutions[Int(value)].date.getDateForKnownFormats()?.getString("dd.MM.yy") ?? .empty
//    }
//}
