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
     
        var accessToken = UserDefaults.standard.object(forKey: K.UserDefaultKeys.accessToken) as? String

        
        let urlString = "https://www.strava.com/api/v3/athlete/activities?access_token=\(accessToken!)"

        guard let url = URL(string: urlString) else {
            print("Error in create url")
            completion(nil)
            return
        }
        

        
        
        var request = URLRequest(url: url)
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

                            return Activity(distance: distance, movingTime: movingTime, starDate: startDate, activityType: activityType)
                        }

                        // Use the 'activities' array of type Activity
                        groupedActivites = GroupedActivities(from: activities)
                        completion(groupedActivites)
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
    
    

    
}

