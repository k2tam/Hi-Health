//
//  CustomActivitiesTblCell.swift
//  StravaSwift_Example
//
//  Created by  OS on 02/06/2566 BE.
//  Copyright © 2566 BE CocoaPods. All rights reserved.
//

import UIKit
import StravaSwift
import MapKit



class CustomActivitiesTblCell: UITableViewCell, MKMapViewDelegate {
    static let identifier = "CustomActivitiesTblCell"
    @IBOutlet weak var imageMap: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var pace: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var nameAtivities: UILabel!
    @IBOutlet weak var datecell: UILabel!
    @IBOutlet weak var namecell: UILabel!
    @IBOutlet weak var avatercell: UIImageView!
   
    
    @IBOutlet weak var imgMap: UIImageView!
    
    var annotations: [CLLocationCoordinate2D] = []
    
    var apicall = APIRequestMap()
    let formatter1 = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        
        avatercell.layer.cornerRadius = 25
       
    }
    func loadmap(_ id: Int, callback: @escaping ((UIImage) -> Void)){
        
        apicall.urlString = URL(string:"https://www.strava.com/api/v3/activities/8959416658/streams")
        
        apicall.requestAPIInfo(id){ [weak self] latlng in
            
            //
            
            let arraydata = latlng.latlng.data
            
            var minLat = arraydata.first?.first
            var maxLat = minLat
            var minLng = arraydata.last?.last
            var maxLng = minLng

            for element in arraydata {
                minLat = min(minLat!, element.first!)
                maxLat = max(maxLat!, element.first!)
                minLng = min(minLng!, element.last!)
                maxLng = max(maxLng!, element.last!)
                
                self!.annotations.append(CLLocationCoordinate2D(latitude: element.first!, longitude:element.last!))
                
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
                        
                        guard let annotations = self?.annotations, annotations.count > 1 else { return }
                        
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
                    self?.imgMap.image = render
                    // Process or display the image as needed
                } else if let error = error {
                    // Handle the error
                }
            }
        }
    }
    private func secondsToHoursMinutesSeconds(seconds: Double) -> (Double, Double, Double) {
      let (hr,  minf) = modf(seconds / 3600)
      let (min, secf) = modf(60 * minf)
      return (hr, min, 60 * secf)
    }
    func setUI(_ athlete: Athlete, _ activities: [Activity],_ index: Int,_ listnew: [Example], cachedImage: UIImage?, callback: @escaping ((UIImage) ->Void)){
        if(activities.isEmpty){
            self.namecell.text = "\(athlete.firstname ?? "") \(athlete.lastname ?? "")"
            self.avatercell?.from(url: athlete.profile)
            self.nameAtivities.text = listnew[index].name
            self.distance.text = String(format:"%.2f",(listnew[index].distance)/1000)+" Km"
            let (h,m,_) = secondsToHoursMinutesSeconds(seconds: Double(listnew[index].movingTime ))
            self.time.text = String(format:"%.0f",h)+":"+String(format:"%.0f",m)+" m"
            self.pace.text = String(format: "%.2f", (listnew[index].movingTime/60)/(Int(listnew[index].distance)/1000))+" /Km"
            self.datecell.text = listnew[index].startDateLocal
            
        }else{
            self.namecell.text = "\(athlete.firstname ?? "") \(athlete.lastname ?? "")"
            self.avatercell?.from(url: athlete.profile)
            self.nameAtivities.text = activities[index].name
            self.distance.text = String(format:"%.2f",(activities[index].distance!)/1000)+" Km"
            let (h,m,_) = secondsToHoursMinutesSeconds(seconds: activities[index].movingTime ?? 00)
            self.time.text = String(format:"%.0f",h)+":"+String(format:"%.0f",m)+" m"
            self.pace.text = String(format: "%.2f", (activities[index].movingTime!/60)/(activities[index].distance!/1000))+" /Km"
            formatter1.dateStyle = .short
            self.datecell.text = formatter1.string(from: activities[index].startDate! )
            // neu da cache roi thi k download / render lai
            if let img = cachedImage {
                self.imgMap.image = img
            } else {
                self.loadmap(activities[index].id!){ image in
                    callback(image)
                }
            }
            
        }
        self.selectionStyle = .none
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

