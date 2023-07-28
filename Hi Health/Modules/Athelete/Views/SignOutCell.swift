//
//  SignOut.swift
//  Hi Health
//
//  Created by k2 tam on 27/07/2023.
//

import UIKit

protocol SignOutCellDelegate {
    func didPressSignOut()
}

class SignOutCell: UITableViewCell {
    
    var delegate: SignOutCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func signOutPressed(_ sender: UIButton) {
        delegate?.didPressSignOut()

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
