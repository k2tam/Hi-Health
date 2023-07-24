//
//  Profile.swift
//  Hi Health
//
//  Created by k2 tam on 14/07/2023.
//

import Foundation
import SwiftyJSON

struct Athlete: Codable {
    let firstName: String
    let lastName: String
    let state: String
    let country: String
    let sex: String
    let profile: String
    let profileMedium: String
    
    
    init(from json: JSON){
        self.firstName = json["firstname"].stringValue
        self.lastName = json["lastname"].stringValue
        self.state = json["state"].stringValue
        self.country = json["country"].stringValue
        self.sex = json["sex"].stringValue
        self.profile = json["profile"].stringValue
        self.profileMedium = json["profile_medium"].stringValue
    }
}
