//
//  Profile.swift
//  Hi Health
//
//  Created by k2 tam on 14/07/2023.
//

import Foundation
import SwiftyJSON

struct Athlete: Codable {
    let firstName: String?
    let lastName: String?
    let state: String?
    let country: String?
    let sex: String?
    let profile: String?
    let profileMedium: String?
    
    
    init(from json: JSON){
        self.firstName = json["firstname"].string
        self.lastName = json["lastname"].string
        self.state = json["state"].string
        self.country = json["country"].string
        self.sex = json["sex"].string
        self.profile = json["profile"].string
        self.profileMedium = json["profile_medium"].string
    }
}
