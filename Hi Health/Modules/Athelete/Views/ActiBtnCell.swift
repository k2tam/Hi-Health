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
    
    var activityTypeModel: SpecificActivity? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateUIBtnCell()
            }
        }
    }
      
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        
        // Set corner radius
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }
    

    
}

//Methods for UI
extension ActiBtnCell {
    private func updateUIBtnCell() {
        actiBtnLabel.text = activityTypeModel?.typeActivity ?? ""
        actiBtnIcon.image = activityTypeModel?.activityIcon ?? UIImage()
    }
    
    func updateUIForSelectedIndex() {
        actiBtnLabel.textColor = .orange
        self.layer.borderColor = UIColor.orange.cgColor
        actiBtnIcon.tintColor = .orange
    }
    
    func updateUIForUnSelectedIndex() {
        actiBtnLabel.textColor = .black
        self.layer.borderColor = UIColor.black.cgColor
        actiBtnIcon.tintColor = .black
    }
}
