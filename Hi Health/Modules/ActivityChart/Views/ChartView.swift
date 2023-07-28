//
//  ChartView.swift
//  Hi Health
//
//  Created by k2 tam on 26/07/2023.
//

import UIKit
import Charts

protocol CustomChartViewDelegate {
    func didSelectABar(activity: Activity)
}

class ChartView: BarChartView {
    var customDelegate: CustomChartViewDelegate?
    var actiModels: [Activity]? {
        didSet {
            setCustomXAxisLabels()
            
        }
    }
    var chartData: BarChartData? {
        didSet {
            setChartData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setChartData() {
        
        
        guard let chartData = chartData else {
            self.data = BarChartData()
            return
        }
        
        
        self.delegate = self
        self.data = chartData
        
    }
    
    private func setCustomXAxisLabels() {
        guard let actiModels = actiModels else { return }
        
        //         Calculate the desired bar width based on the number of data points
        let barWidth = 1.0 / Double(actiModels.count)
        
        // Set the bar width
        if let barData = self.barData {
            barData.barWidth = barWidth
        }
        
        xAxis.setLabelCount(actiModels.count, force: false)

    
    }
    
    private func setupView() {
        configChart()
    }
    
    
    private func configChart() {
        // Disable scrolling in the chart
        let yAxis = self.rightAxis
        
        self.dragEnabled = false
        self.setScaleEnabled(false)
        
        self.xAxis.labelFont = .boldSystemFont(ofSize: 10)
        yAxis.labelFont = .boldSystemFont(ofSize: 10)
            
        // Adjust the Y-axis position
        self.leftAxis.enabled = false // Enable the right Y-axis
        self.leftAxis.drawLabelsEnabled = false // Hide labels on the right Y-axis
        self.xAxis.labelPosition = .bottom
        
        // Remove the grid lines
        self.xAxis.drawGridLinesEnabled = false
        self.leftAxis.drawGridLinesEnabled = false
        self.rightAxis.drawGridLinesEnabled = false
        
        
        //Remove legend
        self.legend.enabled = false
        
    }
}

extension ChartView: ChartViewDelegate{
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let actiModels = actiModels else { return }
        
        let actiModelSelected = actiModels.first { actiModel in
            actiModel.getDayMonth.day == Int(entry.x)
        }
        
        if let actiModelSelected = actiModelSelected {
            customDelegate?.didSelectABar(activity: actiModelSelected)
            
        }
        
    }
}



