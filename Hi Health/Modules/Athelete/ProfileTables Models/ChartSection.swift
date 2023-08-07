//
//  Chart.swift
//  Hi Health
//
//  Created by k2 tam on 14/07/2023.
//

import Foundation
import UIKit
import SwiftyJSON


struct SpecificActivity {
    var typeActivity: String
    var activities: [Activity]
    
    var activityIcon: UIImage {
        switch typeActivity {
        case "EBikeRide":
            return UIImage(systemName: "bicycle")!
        default:
            return UIImage(systemName: "figure.walk")!
        }
    }
    
   
    var descOrderedActivites: [Activity] {
        return activities.sorted { (activity1, activity2) -> Bool in
            
            return activity1.startDate > activity2.startDate
            
        }
    }
    
    var ascOrderedActivites: [Activity] {
        return activities.sorted { (activity1, activity2) -> Bool in
            
            return activity1.startDate < activity2.startDate
            
        }
    }
    
    func getAcivitesGroupedByDate(isDesc: Bool?) -> [Activity]{
        var groupedActivities: [String: Activity] = [:]
        
        // Process all activities
        // Đủ data activites
        for activity in ascOrderedActivites {
            let actiDayMonth = activity.formattedStartDate
            
            // Check if there is an entry with the same start date
            if var existingActivity = groupedActivities[actiDayMonth]  {
                // If yes, update distance and movingTime
                existingActivity.distance += activity.distance
                existingActivity.movingTime += activity.movingTime
                groupedActivities[actiDayMonth] = existingActivity
            } else {
                // If not, add a new entry
                groupedActivities[actiDayMonth] = activity
            }
        }
        
        var groupedByDateActivites = Array(groupedActivities.values)
        
        
        guard let isDesc = isDesc else {
            //Sort by asc of startDate
            return groupedByDateActivites.sorted { (activity1, activity2) -> Bool in
                
                return activity1.startDate < activity2.startDate
                
            }
        }
        
        //Sort by desc of startDate
        return groupedByDateActivites.sorted { (activity1, activity2) -> Bool in
            
            return activity1.startDate > activity2.startDate
            
        }
    }
}



struct GroupedActivities {
    var activities: [SpecificActivity]  = []
    
    init(from activities: [Activity]){
        var dexArr: [SpecificActivity]  = []
        
        var groupedActivitiesDex: [String: [Activity]] = [:]
        
        for acti in activities{
            if var group = groupedActivitiesDex[acti.activityType ] {
                group.append(acti)
                groupedActivitiesDex[acti.activityType ] = group
            } else {
                groupedActivitiesDex[acti.activityType] = [acti]
            }
        }
        
        for (activityType, activities) in groupedActivitiesDex {
            dexArr.append(SpecificActivity(typeActivity: activityType, activities: activities))
        }
        
        self.activities = dexArr
        
    }
    
    
}

struct ChartSection {
    let groupedActivies: [SpecificActivity]?
}

struct Activity {
    var distance: Double
    var movingTime: Int
    let startDate: String
    let activityType: String
    
    var getDayMonthYear: (day: Int, month: Int, year: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: startDate) {
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)
            let year = calendar.component(.year, from: date)

            return (day, month, year)
        } else {
            return (0,0,0)
        }
    }
    
    var formattedStartDate: String {
        let inputDateFormatter = ISO8601DateFormatter()
        inputDateFormatter.formatOptions = [.withInternetDateTime]
        
        if let date = inputDateFormatter.date(from: startDate) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "dd/MM/yyyy"
            return outputDateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    var distanceString: String {
        
        
        return  String(format: "%.2f km", distance/1000.0)
    }
    
    var timeString: String {
        
        
        let hours = movingTime / 3600
        let minutes = (movingTime % 3600) / 60
        let seconds = movingTime % 3600  % 60
        
        var formattedTime = ""
        
        if hours > 0 {
            formattedTime += "\(hours)h "
        }
        
        if minutes > 0 {
            formattedTime +=  "\(minutes)m "
        }
        
        formattedTime += "\(seconds)s"
        
        
        return  formattedTime
    }
    
    var activityIcon: UIImage {
        switch activityType {
        case "EBikeRide":
            return UIImage(systemName: "bicycle")!
        default:
            return UIImage(systemName: "figure.walk")!
        }
    }
}

