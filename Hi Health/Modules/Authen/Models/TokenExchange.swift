//
//  Authen.swift
//  Hi Health
//
//  Created by k2 tam on 12/07/2023.
//

import Foundation
import SwiftyJSON


struct TokenExchange: Codable {
    let refreshToken: String?
    let accessToken: String?
    let expiresAt: Int?
    let athleteId: Int?
    let athleteInfo: Athlete?
    
    init(refreshToken: String?, accessToken: String?, expiresAt: Int?, athleteId: Int?, athleteInfo: Athlete?) {
        self.refreshToken = refreshToken
        self.accessToken = accessToken
        self.expiresAt = expiresAt
        self.athleteId = athleteId
        self.athleteInfo = athleteInfo
    }
    
    init(from json: JSON){
        self.refreshToken = json["refresh_token"].string
        self.accessToken = json["access_token"].string
        self.expiresAt = json["expires_at"].int
        self.athleteId = json["athlete"]["id"].int
        self.athleteInfo = Athlete(from: json["athlete"])
    }
    
 
}


