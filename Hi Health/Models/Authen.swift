//
//  Authen.swift
//  Hi Health
//
//  Created by k2 tam on 12/07/2023.
//

import Foundation


struct AuthenModel: Codable {
    let refreshToken: String?
    let accessToken: String?
    

    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
        case accessToken = "access_token"
    }
    
    
}
