//
//  ChartViewModel.swift
//  Hi Health
//
//  Created by k2 tam on 26/07/2023.
//

import Foundation
import Charts

protocol ChartViewModelDelegate {
    func didGetNewChartData(chartData: LineChartData, actiModelsList: [Activity])
    func clearChartData()
}

class ChartViewModel {
    var delegate: ChartViewModelDelegate?
    
  
    func updateChartData(activities: [Activity]?) {
        guard let activities = activities else {
            return
        }
        
        var dataEntries: [ChartDataEntry] = []
 
        for actiModel in activities {
            
            let dataEntry = ChartDataEntry(x: Double(actiModel.getDayMonthYear.day), y: actiModel.distance/1000)
            dataEntries.append(dataEntry)
        }
        
        let dataSet = LineChartDataSet(entries: dataEntries)
        
        let data = LineChartData(dataSet: dataSet)
        
        delegate?.didGetNewChartData(chartData: data,actiModelsList: activities)
    }
}


