//
//  ActivitiesListVM.swift
//  Hi Health
//
//  Created by TaiVC on 7/25/23.
//

import Foundation
import SwiftyJSON
import Alamofire

struct ActivitiesListVM {
    fileprivate var activities: [ActivitiesIteamModel]
    
    init(json: JSON?) {
        if let json = json {
            self.activities = json.arrayValue.map({ return ActivitiesIteamModel(json: $0)})
        }
        else {
            self.activities = []
        }
    }
    
    func getTotalActivities() -> Int {
        return activities.count
    }
    
    func getActivitiesAtIndex(index: Int) -> ActivitiesIteamModel? {
        return activities[index]
    }

}
