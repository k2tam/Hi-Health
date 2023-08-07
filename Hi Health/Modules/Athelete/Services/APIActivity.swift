//
//  APIActivity.swift
//  Hi Health
//
//  Created by k2 tam on 17/07/2023.
//

import Foundation
import SwiftyJSON


class APIActvity {
    static let shared = APIActvity()
    
    let calendar = Calendar.current
    
    
    private init() {}
    
    func getAfterBeforeTimeStampForMonth(month: Int) -> (afterTS: Int, beforeTS: Int) {
        // Create Date objects for July 1, 2023, and August 1, 2023
        let afterDateComponents = DateComponents(year: 2023, month: month, day: 1)
        let beforeDateComponents = DateComponents(year: 2023, month: month + 1, day: 1)
        
        if let afterDate = calendar.date(from: afterDateComponents),
           let beforeDate = calendar.date(from: beforeDateComponents) {
            
            // Convert Date objects to epoch timestamps (Unix timestamps)
            let afterTimestamp = Int(afterDate.timeIntervalSince1970)
            let beforeTimestamp = Int(beforeDate.timeIntervalSince1970)
            
            return (afterTimestamp, beforeTimestamp)
            
        }else{
            print("Failed to get DM")
            return (0,0)
        }
 
    }
    
    func fetchAthleteGroupedActivitiesData(month: Int?,completion: @escaping (_ groupedActivites : GroupedActivities?) -> Void)  {   
        var groupedActivites: GroupedActivities?

//        let accessToken = TokenDataManager.shared.getAccessToken()
        //        let urlString = "https://www.strava.com/api/v3/athlete/activities?access_token=\(accessToken)"
        
        var monthToFetch: Int
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Extract the month component from the current date
        let currentMonth = calendar.component(.month, from: currentDate)
        
        if let month = month {
            monthToFetch = month
        }else{
            monthToFetch = currentMonth
        }
            
        let accessToken =  TokenDataManager.shared.getAccessToken()
        
        
        let afterBeforeTs = getAfterBeforeTimeStampForMonth(month: monthToFetch)
        
        let urlString = "https://www.strava.com/api/v3/athlete/activities?access_token=\(accessToken)&after=\(afterBeforeTs.afterTS)&before=\(afterBeforeTs.beforeTS)"
        
        
        guard let url = URL(string: urlString) else {
            print("Error in create url")
            completion(nil)
            return
        }
        
        
        let request = URLRequest(url: url)
        //Add required headers to fetch athelete data
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, _, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }
            
            if let data = data {
                do {
                    let json = try JSON(data: data)
                    
                    
                    if let jsonArray = json.arrayObject as? [[String: Any]] {
                        let activities = jsonArray.compactMap { activityDict -> Activity? in
                            guard let distance = activityDict["distance"] as? Double,
                                  let movingTime = activityDict["moving_time"] as? Int,
                                  let startDate = activityDict["start_date"] as? String,
                                  let activityType = activityDict["type"] as? String else {
                                return nil
                            }
                            
                            return Activity(distance: distance, movingTime: movingTime, startDate: startDate, activityType: activityType)
                        }
                        
                        // Use the 'activities' array of type Activity
                        groupedActivites = GroupedActivities(from: activities)
                        
                        if let groupedActivites = groupedActivites {
                            if(!groupedActivites.activities.isEmpty){
                                completion(groupedActivites)

                            }else{
                                completion(nil)
                            }

                        }else{
                            completion(nil)
                        }
                    } else {
                        // Handle invalid JSON structure
                        completion(nil)
                    }
                    
                }catch{
                    print(error.localizedDescription)
                }
                
            }
        }
        
        task.resume()
        
        
    }
    
    //    func fetchAthleteGroupedActivitiesData(month: Int?,completion: @escaping (_ groupedActivites : GroupedActivities?) -> Void)  {
    //        var monthToFetch: Int
    //
    //        let calendar = Calendar.current
    //        let currentDate = Date()
    //
    //        // Extract the month component from the current date
    //        let currentMonth = calendar.component(.month, from: currentDate)
    //
    //
    //        if let month = month {
    //            monthToFetch = month
    //        }else{
    //            monthToFetch = currentMonth
    //        }
    //
    //        var groupedActivites: GroupedActivities?
    //
    //        let accessToken =  TokenDataManager.shared.getAccessToken()
    //
    //
    //        let afterBeforeTs = getAfterBeforeTimeStampForMonth(month: monthToFetch)
    //
    //        print("afer: \(afterBeforeTs.afterTS)")
    //        print("before: \(afterBeforeTs.beforeTS)")
    //
    //        let urlString = "https://www.strava.com/api/v3/athlete/activities?access_token=\(accessToken)&after=\(afterBeforeTs.afterTS)&before=\(afterBeforeTs.beforeTS)"
    //
    //        APIManager.shared.requestAPI(endPoint: urlString,signatureHeader: true, optionalHeaders: nil, vc: nil) { json, sstc in
    //            if(sstc?.statusCode == StatusCode.SUCCESS.rawValue){
    //                if let jsonArray = json?.arrayObject as? [[String: Any]] {
    //                    let activities = jsonArray.compactMap { activityDict -> Activity? in
    //                        guard let distance = activityDict["distance"] as? Double,
    //                              let movingTime = activityDict["moving_time"] as? Int,
    //                              let startDate = activityDict["start_date"] as? String,
    //                              let activityType = activityDict["type"] as? String else {
    //                            return nil
    //                        }
    //
    //                        return Activity(distance: distance, movingTime: movingTime, startDate: startDate, activityType: activityType)
    //                    }
    //
    //                    // Use the 'activities' array of type Activity
    //                    groupedActivites = GroupedActivities(from: activities)
    //                    completion(groupedActivites)
    //                }
    //                else {
    //                    completion(nil)
    //                }
    //            }else{
    //                completion(nil)
    //            }
    //
    //        }
    
    
}


