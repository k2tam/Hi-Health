//
//  HiHealthStatusResult.swift
//  Hi Health
//
//  Created by TaiVC on 7/25/23.
//

import Foundation


class HiHealthStatusResult{
    public var message:String
    public var statusCode:Int
    
    public init (message:String, statusCode:Int) {
        self.message = message
        self.statusCode = statusCode
    }
}

public enum HiHealthStatusCode: Int{
    init(_ type: Int) {
        if let type = HiHealthStatusCode(rawValue: type) {
            self = type
        } else {
            self = .UNDEFINED
        }
    }
    
    case UNDEFINED = -9999 //
    case CLIENT_ERROR = -1
    case SUCCESS = 200 //Successful request
    case SUCCESS_CREATED = 201 //Your activity/etc. was successfully created
    case UNAUTHORIZED = 401 // Unauthorized
    case FORBIDDEN = 403 // Forbidden; you cannot access
    case NOT_FOUND = 404 // Too Many Requests; you have exceeded rate limits
    case TOO_MANY_REQUESTS // Too Many Requests; you have exceeded rate limits
    case STRAVA_IS_HAVING_ISSUES // Strava is having issues, please check https://status.strava.com
}
