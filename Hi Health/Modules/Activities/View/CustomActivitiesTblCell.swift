//
//  CustomActivitiesTblCell.swift
//  StravaSwift_Example
//
//  Created by  OS on 02/06/2566 BE.
//  Copyright © 2566 BE CocoaPods. All rights reserved.
//

import UIKit

import MapKit
//
//
//
class CustomActivitiesTblCell: UITableViewCell, MKMapViewDelegate {
    
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var pace: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var nameAtivities: UILabel!
    @IBOutlet weak var datecell: UILabel!
    @IBOutlet weak var namecell: UILabel!
    @IBOutlet weak var avatercell: UIImageView!
    @IBOutlet weak var imgMap: UIImageView!
    
    
    var callbackidImge: ((Int) -> ())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatercell.layer.cornerRadius = 25
    }
   
    func setupCell(data: ActivitiesIteamModel, image: UIImage?){
        time.text = String(data.movingTime)
        distance.text = String(data.distance)
        datecell.text = data.startDateLocal
        nameAtivities.text = data.name
        
        if image != nil{
            imgMap.image = image
        }else{
            callbackidImge?(data.id)
        }
    }
    
}
