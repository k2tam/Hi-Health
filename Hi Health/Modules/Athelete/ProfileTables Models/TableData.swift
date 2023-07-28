//
//  Table.swift
//  Hi Health
//
//  Created by k2 tam on 14/07/2023.
//

import Foundation

enum ProfileSectionType {
    case profile(ProfileSection)
    case chart(ChartSection)
    case items(ItemsSection)
    case signOutBtn

}

struct ProfileTable{
    var profileSections: [ProfileSectionType]
    
    init() {
        self.profileSections = []
    }
    
    
}




