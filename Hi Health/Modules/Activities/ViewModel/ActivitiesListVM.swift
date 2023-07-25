//
//  ActivitiesListVM.swift
//  Hi Health
//
//  Created by TaiVC on 7/25/23.
//

import Foundation
import SwiftyJSON

struct ActivitiesListVM {
    private var activities: [ActivitiesModel]
    
    init(json: JSON?) {
        if let json = json {
            self.activities = json.arrayValue.map({ return ActivitiesModel(json: $0)})
        }
        else {
            self.activities = []
        }
    }
    
    func getTotalActivities() -> Int {
        return activities.count
    }
    
    func getActivitiesAtIndex(index: Int) -> ActivitiesModel? {
        return activities[index]
    }
    

}
