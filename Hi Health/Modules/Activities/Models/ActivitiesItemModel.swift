//
//  ActivitiesModel.swift
//  Hi Health
//
//  Created by TaiVC on 7/25/23.
//

import Foundation
import SwiftyJSON

public struct ActivitiesIteamModel{
    var resourceState: Int
    var name: String
    var distance: Double
    var movingTime, elapsedTime, totalElevationGain: Int
    var type, sportType: String
    var workoutType, id: Int
    var startDate, startDateLocal: String
    var timezone: String
    var utcOffset: Int
    var locationCountry: String
    var achievementCount, kudosCount, commentCount, athleteCount: Int
    var photoCount: Int
    var trainer, commute, manual, welcomePrivate: Bool
    var visibility: String
    var flagged: Bool
    var averageSpeed, maxSpeed: Double
    var hasHeartrate, heartrateOptOut, displayHideHeartrateOption: Bool
    var elevHigh, elevLow: Double
    var uploadID: Int
    var uploadIDStr, externalID: String
    var fromAcceptedTag: Bool
    var prCount, totalPhotoCount: Int
    var hasKudoed: Bool
    
    init(resourceState: Int, name: String, distance: Double, movingTime: Int, elapsedTime: Int, totalElevationGain: Int, type: String, sportType: String, workoutType: Int, id: Int, startDate: String, startDateLocal: String, timezone: String, utcOffset: Int, locationCountry: String, achievementCount: Int, kudosCount: Int, commentCount: Int, athleteCount: Int, photoCount: Int, trainer: Bool, commute: Bool, manual: Bool, welcomePrivate: Bool, visibility: String, flagged: Bool, averageSpeed: Double, maxSpeed: Double, hasHeartrate: Bool, heartrateOptOut: Bool, displayHideHeartrateOption: Bool, elevHigh: Double, elevLow: Double, uploadID: Int, uploadIDStr: String, externalID: String, fromAcceptedTag: Bool, prCount: Int, totalPhotoCount: Int, hasKudoed: Bool) {
        self.resourceState = resourceState
        self.name = name
        self.distance = distance
        self.movingTime = movingTime
        self.elapsedTime = elapsedTime
        self.totalElevationGain = totalElevationGain
        self.type = type
        self.sportType = sportType
        self.workoutType = workoutType
        self.id = id
        self.startDate = startDate
        self.startDateLocal = startDateLocal
        self.timezone = timezone
        self.utcOffset = utcOffset
        self.locationCountry = locationCountry
        self.achievementCount = achievementCount
        self.kudosCount = kudosCount
        self.commentCount = commentCount
        self.athleteCount = athleteCount
        self.photoCount = photoCount
        self.trainer = trainer
        self.commute = commute
        self.manual = manual
        self.welcomePrivate = welcomePrivate
        self.visibility = visibility
        self.flagged = flagged
        self.averageSpeed = averageSpeed
        self.maxSpeed = maxSpeed
        self.hasHeartrate = hasHeartrate
        self.heartrateOptOut = heartrateOptOut
        self.displayHideHeartrateOption = displayHideHeartrateOption
        self.elevHigh = elevHigh
        self.elevLow = elevLow
        self.uploadID = uploadID
        self.uploadIDStr = uploadIDStr
        self.externalID = externalID
        self.fromAcceptedTag = fromAcceptedTag
        self.prCount = prCount
        self.totalPhotoCount = totalPhotoCount
        self.hasKudoed = hasKudoed
    }
    init(json: JSON!){
        self.resourceState = json["resourceState"].intValue
        self.name = json["name"].stringValue
        self.distance = json["distance"].doubleValue
        self.movingTime = json["moving_time"].intValue
        self.elapsedTime = json["elapsedTime"].intValue
        self.totalElevationGain = json["totalElevationGain"].intValue
        self.type = json["type"].stringValue
        self.sportType = json["sportType"].stringValue
        self.workoutType = json["workoutType"].intValue
        self.id = json["id"].intValue
        self.startDate = json["startDate"].stringValue
        self.startDateLocal = json["start_date_local"].stringValue
        self.timezone = json["timezone"].stringValue
        self.utcOffset = json["utcOffset"].intValue
        self.locationCountry = json["locationCountry"].stringValue
        self.achievementCount = json["achievementCount"].intValue
        self.kudosCount = json["kudosCount"].intValue
        self.commentCount = json["commentCount"].intValue
        self.athleteCount = json["athleteCount"].intValue
        self.photoCount = json["photoCount"].intValue
        self.trainer = json["trainer"].boolValue
        self.commute = json["commute"].boolValue
        self.manual = json["manual"].boolValue
        self.welcomePrivate = json["welcomePrivate"].boolValue
        self.visibility = json["visibility"].stringValue
        self.flagged = json["flagged"].boolValue
        self.averageSpeed = json["averageSpeed"].doubleValue
        self.maxSpeed = json["maxSpeed"].doubleValue
        self.hasHeartrate = json["hasHeartrate"].boolValue
        self.heartrateOptOut = json["heartrateOptOut"].boolValue
        self.displayHideHeartrateOption = json["displayHideHeartrateOption"].boolValue
        self.elevHigh = json["elevHigh"].doubleValue
        self.elevLow = json["elevLow"].doubleValue
        self.uploadID = json["uploadID"].intValue
        self.uploadIDStr = json["uploadIDStr"].stringValue
        self.externalID = json["externalID"].stringValue
        self.fromAcceptedTag = json["fromAcceptedTag"].boolValue
        self.prCount = json["prCount"].intValue
        self.totalPhotoCount = json["totalPhotoCount"].intValue
        self.hasKudoed = json["hasKudoed"].boolValue
    }
}
