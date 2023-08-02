//
//  ActivitiesVM.swift
//  Hi Health
//
//  Created by TaiVC on 7/25/23.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation
import MapKit

class ActivitiesVM {
    
    let defaults = UserDefaults.standard
    
    var annotationsIndex : [Int : [CLLocationCoordinate2D]] = [:]
    
    fileprivate(set) var latlog: LatLngModel?
    fileprivate(set) var currentItem: ActivitiesIteamModel?
    fileprivate var model: ActivitiesListVM? {
        didSet {
            actionBindingData?()
        }
    }
    
    var actionBindingData: (() -> Void)?
    var actionCode: (() -> Void)?
    var getTotalActivities: Int{
        return model?.getTotalActivities() ?? 0
    }
    
    var gettoken: String {
        return TokenDataManager.shared.getAccessToken()
    }
    func getActivitiesInfo(atIndex index: Int) -> ActivitiesIteamModel{
        return model!.getActivitiesAtIndex(index: index)!
    }
    func getLatlng() -> LatLngModel{
        return self.latlog!
    }
    func getNameavatar() -> [String]{
        let data = TokenDataManager.shared.getNameAvatar()
        return data
    }
    func secondsToHoursMinutesSeconds(seconds: Double) -> String {
      let (hr,  minf) = modf(seconds / 3600)
        let (min, secf) = modf(60 * minf)
        if(hr == 0 && min == 0){
            return "\(String(format:"%.0f",60 * secf))s"
        }else if(hr == 0){
            return "\(String(format:"%.0f",min))m:\(String(format:"%.0f",60 * secf))s"
        }else {
            return String(format:"%.0f",hr)+"h:\(String(format:"%.0f",min))m:\(String(format:"%.0f",60 * secf))s"//(hr, min, 60 * secf)
        }
    }
    func getPace(time: Double, distance: Double) -> String {
        return "\(String(format: "%.2f", (time/60)/(distance/1000))) /Km"
    }
    func getDistance(distance: Int) -> String {
        let distanceString = String(format:"%.2f",Double(distance)/1000)+" Km"
        return distanceString
    }
    func formatISO8601Date(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // ISO 8601 format
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy 'at' h:mm a"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    func getImageRun(data: LatLngModel?,id : Int,callback: @escaping ((UIImage)->())){
        
        let arraydata = data?.latlng.data

        var annotations: [CLLocationCoordinate2D] = []
        
        var minLat = arraydata?.first?.first
        var maxLat = minLat
        var minLng = arraydata?.last?.last
        var maxLng = minLng
        
        if arraydata != nil {
            for element in arraydata! {
                minLat = min(minLat!, element.first!)
                maxLat = max(maxLat!, element.first!)
                minLng = min(minLng!, element.last!)
                maxLng = max(maxLng!, element.last!)
                
                annotations.append(CLLocationCoordinate2D(latitude: element.first!, longitude: element.last!))
            }
            
            self.annotationsIndex[id] = annotations
            
            // Calculate the span based on the difference between minimum and maximum coordinates
            let span = MKCoordinateSpan(latitudeDelta: maxLat! - minLat!, longitudeDelta: maxLng! - minLng!)
            
            // Calculate the center coordinate
            let center = CLLocationCoordinate2D(latitude: (minLat! + maxLat!) / 2, longitude: (minLng! + maxLng!) / 2)
            
            // Create an instance of MKMapSnapshotOptions
            let options = MKMapSnapshotter.Options()
            
            // Set the region of the map to include all coordinates
            options.region = MKCoordinateRegion(center: center, span: span)
            
            // Set the size of the map snapshot
            options.size = CGSize(width: 400, height: 250)
            
            // Set the scale of the map snapshot
            options.scale = UIScreen.main.scale
            
            // Set any additional options as needed
            options.showsBuildings = true
            options.pointOfInterestFilter = .excludingAll
            
            let snapshotter = MKMapSnapshotter(options: options)
            snapshotter.start { snapshot, error in
                if let snapshot = snapshot {
                    // The map snapshot is available as an image in the snapshot variable
                    let image = snapshot.image
                    //                    self!.imageMap.image = image
                    let render = UIGraphicsImageRenderer(size: image.size).image{_ in
                        image.draw(at: .zero)

                        
                        var points: [CGPoint] = []
                        self.annotationsIndex[id].map { data in
                            points = data.map { dataj in
                                snapshot.point(for: dataj)
                            }
                        }

                        let path = UIBezierPath()
                        path.move(to: points[0] )
                        
                        for point in points.dropFirst() {
                            path.addLine(to: point )
                            //print(point.x)
                        }
                        path.lineWidth = 2
                        UIColor.blue.setStroke()
                        path.stroke()
                        
                    }
                    callback(render)
                    // Process or display the image as needed
                } else if let error = error {
                    print(error)
                }
            }
        }else{
            
        }
    }
    
    func fetchListActivities(vc: ActivitiesVC){
        let URL = "https://www.strava.com/api/v3/athlete/activities"
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(gettoken)"]
        APIManager.shared.requestAPI(endPoint: URL ,signatureHeader: true,optionalHeaders: headers,vc: vc, handler: { dataJon, errorJson in
            if (errorJson?.statusCode == StatusCode.SUCCESS.rawValue){
                self.model = ActivitiesListVM(json: dataJon)
            }
        })
    }
    func fetchDataMapRun(vc: ActivitiesVC,id idrun: Int,callback: @escaping(JSON)->()){
        let URL = "https://www.strava.com/api/v3/activities/\(idrun)/streams?keys=latlng&key_by_type=true"
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(gettoken)"]
        APIManager.shared.requestAPI(endPoint: URL, signatureHeader: true, optionalHeaders: headers, vc: vc, handler: { dataJon, errorJson in
            if (errorJson?.statusCode == StatusCode.SUCCESS.rawValue){
                callback(dataJon!)
            }
        })
    }
}
