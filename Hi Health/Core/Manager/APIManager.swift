//
//  APIManager.swift
//  Hi Health
//
//  Created by TaiVC on 7/25/23.
//

import Alamofire
import SwiftyJSON

class APIManager{
    
    static var shared: APIManager = APIManager()
    
    static let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 10.0
        
        return Session(configuration: configuration)
    }()
    
    public func requestAPI(endPoint: String, params:Parameters? = nil, methodHTTP: HTTPMethod = .get, signatureHeader:Bool, optionalHeaders:HTTPHeaders?, showProgressLoading:Bool = true, vc:UIViewController?, handler: @escaping (JSON?, HiHealthStatusResult?)->()){
        
        var mHeaders:HTTPHeaders = [:]
        if optionalHeaders != nil {
            optionalHeaders?.forEach({ item in
                mHeaders.add(item)
            })
        }
        
        print("********** ENDPOINT: \(endPoint)")
        print("HEADER: \(mHeaders)")
        print("  BODY: \(params ?? [:]) \n**********")
        
        let _session = signatureHeader ? APIManager.sessionManager : AF
        _session.request(endPoint, method: methodHTTP, parameters: params, encoding: JSONEncoding.default, headers: mHeaders, interceptor: signatureHeader as? RequestInterceptor ).validate().response { (data) in
            
            switch data.result {
            case .success(let json):
                let result = JSON(json as Any)
                print("**** OUTPUT \(endPoint) ****:\n \(result)")
                
                var stCode = HiHealthStatusCode.CLIENT_ERROR.rawValue
                
                if(data.response!.statusCode != 0){
                    stCode = data.response!.statusCode
                }
                
                let statusResult = HiHealthStatusResult(message: result["message"].stringValue, statusCode: stCode)
                
                print("StatusCode: \(statusResult.statusCode)")
                print("*****************")
                
                switch stCode{
                case HiHealthStatusCode.SUCCESS.rawValue:
                    handler(result, statusResult)
                default:
                    handler(result, statusResult)
                    break
                }
                handler(JSON(json ?? Any.self),nil)
            case .failure(let error):
                
                handler(nil, nil)
            }
            
        }
    }
    
}
