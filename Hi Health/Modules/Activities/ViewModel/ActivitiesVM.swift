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

    var annotations: [CLLocationCoordinate2D] = []
    
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
    func getImageRun(callback: @escaping ((UIImage)->())){

        let arraydata = latlog?.latlng.data
        
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
                
                self.annotations.append(CLLocationCoordinate2D(latitude: element.first!, longitude:element.last!))
                
            }
            
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
            snapshotter.start { [self] snapshot, error in
                if let snapshot = snapshot {
                    // The map snapshot is available as an image in the snapshot variable
                    let image = snapshot.image
                    //                    self!.imageMap.image = image
                    let render = UIGraphicsImageRenderer(size: image.size).image{_ in
                        image.draw(at: .zero)
                    
                        
                        let points = annotations.map { annotation in
                            
                            snapshot.point(for: annotation)
                        }
                        
                        let path = UIBezierPath()
                        path.move(to: points[0])
                        
                        for point in points.dropFirst() {
                            path.addLine(to: point)
                            //print(point.x)
                        }
                        path.lineWidth = 1
                        UIColor.blue.setStroke()
                        path.stroke()
                        
                    }
                    callback(render)
                    // Process or display the image as needed
                } else if let error = error {
                    
                }
            }
        }else{
            
        }
    }
    func fetchListActivities(vc: ActivitiesVC){
        let URL = "https://www.strava.com/api/v3/athlete/activities"
        let headers: HTTPHeaders = ["Authorization" : "Bearer 92a023af41ad5f0626e874f5850d8eeec2fac024"]
        APIManager.shared.requestAPI(endPoint: URL ,signatureHeader: true,optionalHeaders: headers,vc: vc, handler: { dataJon, errorJson in
            if (errorJson?.statusCode == StatusCode.SUCCESS.rawValue){
                self.model = ActivitiesListVM(json: dataJon)
            }
        })
    }
    func fetchDataMapRun(vc: ActivitiesVC,id idrun: Int,callback: @escaping()->()){
        let URL = "https://www.strava.com/api/v3/activities/\(idrun)/streams?keys=latlng&key_by_type=true"
        let headers: HTTPHeaders = ["Authorization" : "Bearer 92a023af41ad5f0626e874f5850d8eeec2fac024"]
        APIManager.shared.requestAPI(endPoint: URL, signatureHeader: true, optionalHeaders: headers, vc: vc, handler: { dataJon, errorJson in
            if (errorJson?.statusCode == StatusCode.SUCCESS.rawValue){
                self.latlog = LatLngModel(json: dataJon!)
                callback()
            }
        })
    }
}
