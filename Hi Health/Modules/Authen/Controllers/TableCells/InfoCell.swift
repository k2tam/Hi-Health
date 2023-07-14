//
//  ProfileInfoTableViewCell.swift
//  Hi Health
//
//  Created by k2 tam on 14/07/2023.
//

import UIKit

class InfoCell: UITableViewCell {

    
    @IBOutlet weak var profileAvatar: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var location: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
