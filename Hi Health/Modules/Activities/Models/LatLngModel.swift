//
//  LatLngModel.swift
//  Hi Health
//
//  Created by TaiVC on 7/26/23.
//

import Foundation
import SwiftyJSON

struct LatLngModel{
    var latlng: Latlng
    init(latlng: Latlng) {
        self.latlng = latlng
    }
    init(json: JSON){
        self.latlng = Latlng(json: json["latlng"])
    }
}
struct Latlng{
    var data: [[Double]]
    var seriesType: String
    var originalSize: Int
    var resolution: String
    init(data: [[Double]], seriesType: String, originalSize: Int, resolution: String) {
        self.data = data
        self.seriesType = seriesType
        self.originalSize = originalSize
        self.resolution = resolution
    }
    init(json: JSON){
        if let dataArray = json["data"].array {
                   // Convert the JSON array of arrays to a 2D array of Double values
                   var parsedData: [[Double]] = []
                   for innerArray in dataArray {
                       var subArray: [Double] = []
                       for (_, value) in innerArray {
                           if let doubleValue = value.double {
                               subArray.append(doubleValue)
                           }
                       }
                       parsedData.append(subArray)
                   }
                   self.data = parsedData
               } else {
                   // Fallback if the 'data' key is missing or not an array
                   self.data = []
               }

                // Parse other properties if present
        self.seriesType = json["seriesType"].stringValue
        self.originalSize = json["originalSize"].intValue
        self.resolution = json["resolution"].stringValue
    }
}
