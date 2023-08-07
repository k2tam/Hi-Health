//
//  ChartView.swift
//  Hi Health
//
//  Created by k2 tam on 26/07/2023.
//

import UIKit
import Charts

protocol CustomChartViewDelegate {
    func didSelectAPoint(activity: Activity)
}

class ChartView: LineChartView {
    var customDelegate: CustomChartViewDelegate?
    var actiModels: [Activity]? {
        didSet {
            formatXAxis()
        }
    }
    var chartData: LineChartData? {
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
            self.data = LineChartData()
            return
        }
        
        self.delegate = self
        self.data = chartData
        
        // Access the data set from the chart data
           if let dataSet = chartData.dataSets.first as? LineChartDataSet {
               dataSet.colors = [UIColor.orange] // Set the line color
               dataSet.circleColors = [UIColor.orange] // Set the data point color
               dataSet.circleHoleColor = UIColor.red // Set the color of the data point hole
               dataSet.circleRadius = 4.0 // Set the radius of the data points
           }
        
    }
    
    private func formatXAxis() {
        guard let actiModels = actiModels else { return }
        
        // Create an array to store the x-axis labels
        var xAxisLabels: [String] = []
        
        // Iterate through the activity models and add the day label to the array
        for actiModel in actiModels {
            xAxisLabels.append("\(actiModel.getDayMonthYear.day)")
        }

        // Set the x-axis label count and value formatter
        xAxis.setLabelCount(actiModels.count, force: true)
        

    }
    
    private func setupView() {
        configChart()
    }
    
    
    private func configChart() {
        // Disable scrolling in the chart
        let yAxis = self.rightAxis
        
        if self.scaleX == 1.0 {
            self.zoom(scaleX: 0.5, scaleY: 1, x: 0, y: 0)

        }

        self.setScaleEnabled(false)
        
        
        self.xAxis.labelFont = .boldSystemFont(ofSize: 10)
        
        
        yAxis.labelFont = .boldSystemFont(ofSize: 10)
        yAxis.axisMinimum = 0;
        
        
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
            actiModel.getDayMonthYear.day == Int(entry.x)
        }

        if let actiModelSelected = actiModelSelected {
            highlightValue(nil, callDelegate: false)
            customDelegate?.didSelectAPoint(activity: actiModelSelected)
            
        }
        
    }
   
}




