//
//  ActivitiesVM.swift
//  Hi Health
//
//  Created by TaiVC on 7/25/23.
//

import Foundation
import Alamofire
import SwiftyJSON

class ActivitiesVM{
    
    fileprivate var model: ActivitiesListVM? {
        didSet {
            actionBindingData?()
        }
    }
    
    var actionBindingData: (() -> Void)?
    
    var getTotalActivities: Int{
        return (model?.getTotalActivities())!
    }
    var gettoken: String {
        return TokenDataManager.shared.getAccessToken()
    }
    func fetchListActivities(vc: ActivitiesVC){
       
        let URL = "https://www.strava.com/api/v3/athlete/activities"
        let headers: HTTPHeaders = ["Authorization" : "Bearer c61240f470510cd6bc0923cd2631d8274b7e23a4"]
        APIManager.shared.requestAPI(endPoint: URL ,signatureHeader: true,optionalHeaders: headers,vc: vc, handler: { json, sstc in
            if(sstc?.statusCode == StatusCode.SUCCESS.rawValue){
                self.model = ActivitiesListVM(json: json)
            }
        })
    }
}
