//
//  Profile.swift
//  Hi Health
//
//  Created by k2 tam on 14/07/2023.
//

import Foundation
import UIKit

struct ProfileSection {
    let firstName: String
    let lastName: String
    let state: String
    let country: String
    let avatarUrlString: String
    var rows = 0
    var imgAvatar: UIImage?
    
    var profileNameDisplay: String {
        return "\(firstName) \(lastName)"
    }
    
    var userLocation: String {
        return  "\(state), \(country)"
    }
    
 
}

