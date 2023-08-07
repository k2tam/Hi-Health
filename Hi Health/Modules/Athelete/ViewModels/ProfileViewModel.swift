//
//  ProfileViewModel.swift
//  Hi Health
//
//  Created by k2 tam on 14/07/2023.
//

import Foundation
import UIKit
import SwiftyJSON

class ProfileViewModel {
        
    var tableProfileData = ProfileTable()
    
    var groupedActivites: GroupedActivities?

    
     func performSignOut() {
        APIAuthen.shared.performDeauthorizeRequest(accessToken: TokenDataManager.shared.getAccessToken())
        TokenDataManager.shared.clearUserLocalData()
         
    }

    func fetchProfileTableData(month: Int = 7, completion: @escaping (_ profileTableData: ProfileTable) -> Void ) {

        
        let athleteModel = TokenDataManager.shared.getAthleteModel()
        
        let userInfoSection = ProfileSection(firstName: athleteModel.firstName, lastName: athleteModel.lastName, state: athleteModel.state, country: athleteModel.country, avatarUrlString: athleteModel.profileMedium)
        
        
        APIActvity.shared.fetchAthleteGroupedActivitiesData(month: month) {  groupedActivites in
            
            if let groupedActivites = groupedActivites {
                self.groupedActivites = groupedActivites

                let chartDataSection = ChartSection(groupedActivies: groupedActivites.activities)

                self.tableProfileData.profileSections = [ProfileSectionType.profile(userInfoSection),ProfileSectionType.chart(chartDataSection),ProfileSectionType.signOutBtn]
                
                completion(self.tableProfileData)


            }else {
                self.tableProfileData.profileSections = [ProfileSectionType.profile(userInfoSection),ProfileSectionType.chart(nil), ProfileSectionType.signOutBtn]
            }
         

            completion(self.tableProfileData)

        }


    }
   
}



        

