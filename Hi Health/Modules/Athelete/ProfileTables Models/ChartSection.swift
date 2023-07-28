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
    
    var getDayMonth: (day: Int, month: Int) {
        let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

           if let date = dateFormatter.date(from: starDate) {
               let calendar = Calendar.current
               let day = calendar.component(.day, from: date)
               let month = calendar.component(.month, from: date)
               return (day, month)
           } else {
               return (0,0)
           }
    }
 
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

        
        return  String(format: "%.2f km", distance/1000.0)
    }
    
    var timeString: String {


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

