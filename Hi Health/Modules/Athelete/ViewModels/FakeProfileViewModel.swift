//
//  FakeProfileViewModel.swift
//  Hi Health
//
//  Created by k2 tam on 16/07/2023.
//

import Foundation
import UIKit

class FakeProfileViewModel {
        
    private var tableProfileData = ProfileTable()
    
    
    
    func fetchFakeProfileTable(completion: @escaping (_ profileTableData: ProfileTable) -> Void ) {
        
                
        let userInfoSection = ProfileSection(firstName: "Tam", lastName: "Bui", state: "Ho Chi Minh", country: "VN", avatarUrlString: "https://cf-images.us-east-1.prod.boltdns.net/v1/static/5359769168001/b74b48f9-6c13-452e-8776-ea1ab9074953/74b9774e-a415-4499-8f1a-26e5e0940ecd/1280x720/match/image.jpg")
        
    
        
        
        let groupedActivites = [
            SpecificActivity(typeActivity: "Walk", activities: [Activity(distance: 1852.9, movingTime: 365, starDate: "2023-07-15T13:04:39Z", activityType: "Walk"),Activity(distance: 189.4, movingTime: 117, starDate: "2023-07-17T03:56:32Z", activityType: "Walk")]),
             
             SpecificActivity(typeActivity: "EBikeRide", activities: [Activity(distance: 5805.4, movingTime: 746, starDate: "2023-07-14T11:10:07Z", activityType: "EBikeRide")]
                                             )]
        
        let chartDataSection = ChartSection(groupedActivies: groupedActivites)
        
        
        


        
        tableProfileData.profileSections = [ProfileSectionType.profile(userInfoSection),
            ProfileSectionType.chart(chartDataSection)]
        
//        var groupedActivity = GroupedActivity(from: chartDataSection.activites!)
        
        
        completion(tableProfileData)
        
    }

    
}




