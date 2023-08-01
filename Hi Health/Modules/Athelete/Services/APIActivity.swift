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
    
    private init() {}
    
    func fetchAthleteGroupedActivitiesData(completion: @escaping (_ groupedActivites : GroupedActivities?) -> Void)  {
        var groupedActivites: GroupedActivities?
        
        let accessToken =  TokenDataManager.shared.getAccessToken()
        
        let urlString = "https://www.strava.com/api/v3/athlete/activities?access_token=\(accessToken)"
        
        APIManager.shared.requestAPI(endPoint: urlString, signatureHeader: true, optionalHeaders: nil, vc: nil) { json, sstc in
            if(sstc?.statusCode == StatusCode.SUCCESS.rawValue){
                if let jsonArray = json?.arrayObject as? [[String: Any]] {
                    let activities = jsonArray.compactMap { activityDict -> Activity? in
                        guard let distance = activityDict["distance"] as? Double,
                              let movingTime = activityDict["moving_time"] as? Int,
                              let startDate = activityDict["start_date"] as? String,
                              let activityType = activityDict["type"] as? String else {
                            return nil
                        }
                        
                        return Activity(distance: distance, movingTime: movingTime, starDate: startDate, activityType: activityType)
                    }
                    
                    // Use the 'activities' array of type Activity
                    groupedActivites = GroupedActivities(from: activities)
                    completion(groupedActivites)
                }
                else {
                    completion(nil)
                }
            }
            
        }

        
    }
    
}
