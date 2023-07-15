//
//  ProfileViewModel.swift
//  Hi Health
//
//  Created by k2 tam on 14/07/2023.
//

import Foundation

class ProfileViewModel {
        
    private var apiAuthen: APIAuthen
    private var tableProfileData = ProfileTable()
    
    init(apiService: APIAuthen) {
        self.apiAuthen = apiService
        
    }
    
    func fetchProfileTableData(completion: @escaping (_ profileTableData: ProfileTable) -> Void ) {
        let athleteModel = apiAuthen.athleteModel
        
        guard let athleteModel = athleteModel else {
            
            print("No athelete model")
            return
        }
        
        let userInfoSection = ProfileSection(firstName: athleteModel.firstName!, lastName: athleteModel.lastName!, state: athleteModel.state!, country: athleteModel.country!, avatarUrlString: athleteModel.profileMedium!)
        
        
        
        tableProfileData.profileSections.append(ProfileSectionType.profile(userInfoSection))
        
        completion(tableProfileData)
        
        
    }

    
}
