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
   
    func setupCell(id: Int, moving_Time: String ,Distance: String ,startDateLocal: String ,name: String ,avatar: String,namePerson: String,paces: String, image: UIImage?){
        time.text = moving_Time
        distance.text = Distance
        datecell.text = startDateLocal
        nameAtivities.text = name
        namecell.text = namePerson
        pace.text = paces
        avatercell.from(url: URL(string: avatar))
        if image != nil{
            imgMap.image = image
        }else{
            callbackidImge?(id)
        }
    }
    
}
extension UIImageView {
    func from(url: URL?) {
        guard let url = url else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                // Handle error
                print("Error loading image: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                // Handle invalid image data
                print("Invalid image data")
                return
            }
            
            // Use the loaded image on the main queue
            DispatchQueue.main.async {
                // Update UI or perform any other tasks with the image
                self.image = image
            }
        }

        task.resume()
    }
}
