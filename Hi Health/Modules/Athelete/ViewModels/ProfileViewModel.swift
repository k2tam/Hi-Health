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
        
    private var apiAuthen: APIAuthen
    private var tableProfileData = ProfileTable()
    
    var groupedActivites: GroupedActivities?

    
    init(apiService: APIAuthen) {
        self.apiAuthen = apiService
        
    }
    
    func fetchProfileTableData(completion: @escaping (_ profileTableData: ProfileTable) -> Void ) {
        let athleteModel = apiAuthen.athleteModel
        
        guard let athleteModel = athleteModel else {
            
            print("No athlete model")
            return
        }
        
        
        let userInfoSection = ProfileSection(firstName: athleteModel.firstName!, lastName: athleteModel.lastName!, state: athleteModel.state!, country: athleteModel.country!, avatarUrlString: athleteModel.profileMedium!)
        
        
        APIActvity.shared.fetchAthleteGroupedActivitiesData { [self] groupedActivites in

            if let groupedActivites = groupedActivites {
                self.groupedActivites = groupedActivites

                let chartDataSection = ChartSection(groupedActivies: groupedActivites.activites)

                tableProfileData.profileSections = [ProfileSectionType.profile(userInfoSection),ProfileSectionType.chart(chartDataSection)]
                completion(self.tableProfileData)


            }
        }


//        let chartDataSection = ChartSection(groupedActivies: groupedActivites?.activites)
        
//
//        let groupedActivites = [
//            SpecificActivity(typeActivity: "Walk", activities: [Activity(distance: 1852.9, movingTime: 365, starDate: "2023-07-15T13:04:39Z", activityType: "Walk"),Activity(distance: 189.4, movingTime: 117, starDate: "2023-07-17T03:56:32Z", activityType: "Walk")]),
//
//             SpecificActivity(typeActivity: "EBikeRide", activities: [Activity(distance: 5805.4, movingTime: 746, starDate: "2023-07-14T11:10:07Z", activityType: "EBikeRide")]
//                                             )]
//
        let chartDataSection = ChartSection(groupedActivies: [])
        
        
        tableProfileData.profileSections = [ProfileSectionType.profile(userInfoSection),ProfileSectionType.chart(chartDataSection)]
        

        
        completion(tableProfileData)
        
    }
   
}



        
