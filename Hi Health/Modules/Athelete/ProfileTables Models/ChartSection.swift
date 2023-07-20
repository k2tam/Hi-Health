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
//               if let date1 = activity1.starDate, let date2 = activity2.starDate {
//                   return date1 > date2
//               }
//               return false
            return activity1.starDate > activity2.starDate
            
           }
    }
    
    var ascOrderedActivites: [Activity] {
        return activities.sorted { (activity1, activity2) -> Bool in

            return activity1.starDate < activity2.starDate
            
           }
    }
}

struct GroupedActivities {
    var activites: [SpecificActivity]  = []

    init(from activities: [Activity]){
        var dexArr: [SpecificActivity]  = []

        var groupedActivitiesDex: [String: [Activity]] = [:]

        for acti in activities{
            if var group = groupedActivitiesDex[acti.activityType ?? ""] {
                group.append(acti)
                groupedActivitiesDex[acti.activityType ?? ""] = group
            } else {
                groupedActivitiesDex[acti.activityType ?? ""] = [acti]
            }
        }

        for (activityType, activities) in groupedActivitiesDex {
            dexArr.append(SpecificActivity(typeActivity: activityType, activities: activities))
        }
        
        self.activites = dexArr
        
    }
}



struct ChartSection {
    let groupedActivies: [SpecificActivity]?
}

struct Activity {
    let distance: Double
    let movingTime: Int
    let starDate: String
    let activityType: String
    
    var formattedStartDate: String {
            let inputDateFormatter = ISO8601DateFormatter()
            inputDateFormatter.formatOptions = [.withInternetDateTime]

            if let date = inputDateFormatter.date(from: starDate) {
                let outputDateFormatter = DateFormatter()
                outputDateFormatter.dateFormat = "dd/MM/yyyy"
                return outputDateFormatter.string(from: date)
            } else {
                return ""
            }
        }
    
    var distanceString: String {
//        guard let distance = distance else {
//            return "0,00 km"
//        }
        
        return  String(format: "%.2f km", distance/1000.0)
    }
    
    var timeString: String {
//        guard let movingTime = movingTime else {
//            return "0h"
//        }
        
        
        
        
        let hours = movingTime / 3600
        let minutes = movingTime / 60
        let remainingSeconds = movingTime % 60
        
        var formattedTime = ""

        if hours > 0 {
            formattedTime += "\(hours)h "
        }
        
        if minutes > 0 {
            formattedTime +=  "\(minutes)m "
        }
        
        formattedTime += "\(remainingSeconds % 60)s"

        
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


