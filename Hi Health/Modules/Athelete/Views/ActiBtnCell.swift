//
//  ActiBtnCell.swift
//  Hi Health
//
//  Created by k2 tam on 17/07/2023.
//

import UIKit

class ActiBtnCell: UICollectionViewCell {

    @IBOutlet weak var actiBtnIcon: UIImageView!
    @IBOutlet weak var actiBtnLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        
        // Set corner radius
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }

}
