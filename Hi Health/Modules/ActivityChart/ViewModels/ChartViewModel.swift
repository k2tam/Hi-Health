//
//  ChartViewModel.swift
//  Hi Health
//
//  Created by k2 tam on 26/07/2023.
//

import Foundation
import Charts

protocol ChartViewModelDelegate {
    func didGetNewChartData(barChartData: BarChartData, actiModelsList: [Activity])
}

class ChartViewModel {
    var delegate: ChartViewModelDelegate?
    
  
    func updateChartData(activities: [Activity]) {
        var dataEntries: [BarChartDataEntry] = []
        
        
        
        for actiModel in activities {
            let dataEntry = BarChartDataEntry(x: Double(actiModel.getDayMonth.day), y: actiModel.distance/1000)
            dataEntries.append(dataEntry)
        }
        
        let dataSet = BarChartDataSet(entries: dataEntries)
        
        let data = BarChartData(dataSet: dataSet)
        
        delegate?.didGetNewChartData(barChartData: data,actiModelsList: activities)
    }
    
    
    

}


