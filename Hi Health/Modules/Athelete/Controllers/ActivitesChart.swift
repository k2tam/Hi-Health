//
//  ActivitesChart.swift
//  Hi Health
//
//  Created by k2 tam on 20/07/2023.
//

import Foundation
import Charts
import SwiftUI



struct ActiChartModel: Identifiable {
    let id = UUID()
    let amount: Double
    let createAt: Date
    
    
    private static var dateFormatter: DateFormatter  {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy"
        return df
    }
    
    init(from activity: Activity){
        self.amount = activity.distance
        self.createAt = ActiChartModel.dateFormatter.date(from: activity.formattedStartDate) ?? Date()
        
    }
}

struct ActivitesChart: View {
    var activitiesList: [Activity]?
    
    var list: [ActiChartModel] = []
    
    
    init(activities: [Activity]) {
        self.list = activities.map({ activity in
            return ActiChartModel(from: activity)
        })
        
       
    }
    
    
    
   
    func formatDate(_ date: Date) -> String {
        let cal = Calendar.current
        let dateComponent = cal.dateComponents([.day,.month], from: date)
        guard let day = dateComponent.day, let month = dateComponent.month else {
            return "_"
        }
        
        return "\(day)/\(month)"
    }
    
    static var dateFormatter: DateFormatter  {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy"
        return df
    }
    
    
    var body: some View {
        
        Chart(list) { actiChartModel in
            LineMark(
                x: .value("Day", formatDate(actiChartModel.createAt)),
                y: .value("Distance", actiChartModel.amount/1000)
            )
            
            PointMark(
                x: .value("Day", formatDate(actiChartModel.createAt)),
                y: .value("Distance", actiChartModel.amount/1000)
            )
            
            
        }
        .foregroundColor(.orange)
    }
    
    
}
