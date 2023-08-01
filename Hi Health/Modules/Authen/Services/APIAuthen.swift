//
//  APIService.swift
//  Hi Health
//
//  Created by k2 tam on 12/07/2023.
//
//
import Foundation
import AuthenticationServices
import SwiftyJSON
import Alamofire

protocol APIServiceDelegate {
    func didSuccessAuthorized()
    
}

class APIAuthen {
    static var shared: APIAuthen = APIAuthen()

    let clientID = "108189"
    let clientSecret = "3abb1e1776afd45f08ec908133f11f2eaf2168f2"
    let redirectUri = "myapp://developers.strava.com"
    let scope = "read_all,activity:read_all,activity:write,activity:read"
    
    let defaults = UserDefaults.standard
    var delegate: APIServiceDelegate?
    
    public func performDeauthorizeRequest(accessToken: String) {
        
        
        let urlString = "https://www.strava.com/oauth/deauthorize"
        
        let parameters: [String: Any] = ["access_token": accessToken]


        APIManager.shared.requestAPI(endPoint: urlString,params: parameters, methodHTTP: .post, signatureHeader: true, optionalHeaders: nil, vc: nil) { json, response in
            if(response?.statusCode == StatusCode.SUCCESS.rawValue){
                if let json = json {
                    print("Access token revoked: \(String(describing: json["access_token"].string))")

                }
            }
            else{
                print("Failed to de authorize")
            }
        }
    }
    
    func didGetTokenExchanged(tokenExchange: TokenExchange) {
        TokenDataManager.shared.saveData(tokenExchange: tokenExchange)

        DispatchQueue.main.async {
            self.delegate?.didSuccessAuthorized()
        }
    }
    
    func getNewTokenExchange(refreshToken: String) {
        let urlString = "https://www.strava.com/oauth/token?grant_type=refresh_token&client_id=\(clientID)&client_secret=\(clientSecret)&refresh_token=\(refreshToken)"
        
        
        performRequestGetTokenExchange(url: urlString) { tokenExchange in
            TokenDataManager.shared.saveRefreshTokenData(tokenExchange: tokenExchange)
            
            self.checkLoginStatus()

//            self.checkLoginStatus(checked: true)
        }
        
    }
    
    func checkLoginStatus() {
        
        let URL = "https://www.strava.com/api/v3/athlete"
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(TokenDataManager.shared.getAccessToken())"]
        
        APIManager.shared.requestAPI(endPoint: URL, signatureHeader: true, optionalHeaders: headers, vc: nil) {[weak self]  _, errorJson in
            if let statusCode = errorJson?.statusCode, statusCode == StatusCode.UNAUTHORIZED.rawValue {
                // Token expired, try to refresh the token
                self?.getNewTokenExchange(refreshToken: String(TokenDataManager.shared.getRefreshToken()))
            } else {
                // Handle the API response here (success or other errors)
                self?.delegate?.didSuccessAuthorized()
                return

            }
        }

        let expiresAtTimestamp: TimeInterval = Double(TokenDataManager.shared.getTokenExpiresAt())
        let currentTimestamp = Date().timeIntervalSince1970

        // Compare the expiration timestamp with the current timestamp
        if expiresAtTimestamp != 0 && expiresAtTimestamp < currentTimestamp {
            // Token might be expired, attempt to refresh the token
            getNewTokenExchange(refreshToken: String(TokenDataManager.shared.getRefreshToken()))
        } else {
            // Token is still valid
            delegate?.didSuccessAuthorized()
            return
        }
        
//
//        APIManager.shared.requestAPI(endPoint: URL ,signatureHeader: true,optionalHeaders: headers,vc: nil, handler: { _, errorJson in
//            if (errorJson?.statusCode == StatusCode.UNAUTHORIZED.rawValue){
//                //Token expired
//                self.getNewTokenExchange(refreshToken: String(TokenDataManager.shared.getRefreshToken()))
//            }
//        })
//
//        let expiresAtTimestamp: TimeInterval = Double(TokenDataManager.shared.getTokenExpiresAt())
//        // Get the current timestamp
//
//        let currentTimestamp = Date().timeIntervalSince1970
//
//
//        // Compare the expiration timestamp with the current timestamp
//        if  expiresAtTimestamp != 0 {
//            if expiresAtTimestamp < currentTimestamp {
//                getNewTokenExchange(refreshToken: String(TokenDataManager.shared.getRefreshToken()))
//
//
//            } else {
//                //token is still valid
//                delegate?.didSuccessAuthorized()
//            }
//        }
        
    }

    func authorize(viewController: UIViewController) {
        let appOAuthUrlStravaSchemeString =  "strava://oauth/mobile/authorize?client_id=\(clientID)&redirect_uri=\(redirectUri)&response_type=code&approval_prompt=auto&scope=\(scope)&state=test"
        
        let webOAuthUrlString =  "https://www.strava.com/oauth/mobile/authorize?client_id=\(clientID)&redirect_uri=\(redirectUri)&response_type=code&approval_prompt=auto&scope=\(scope)&state=test"
    
        guard let appOAuthUrlStravaScheme = URL(string: appOAuthUrlStravaSchemeString) else { return }
        guard let webOAuthUrl = URL(string: webOAuthUrlString) else {return}
        

        ///Authorize with app
        if(UIApplication.shared.canOpenURL(appOAuthUrlStravaScheme)){
            UIApplication.shared.open(appOAuthUrlStravaScheme, options: [:])
            
        }else {
            ///Authorize with web
            let authSession: ASWebAuthenticationSession
            
            authSession = ASWebAuthenticationSession(url: webOAuthUrl, callbackURLScheme: "myapp") { url, error in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let url = url else {return}
                
                //Get code for exchanging
                if let code = self.extractAuthorizationCode(from: url){

                    
                    let urlForExchangeString = "https://www.strava.com/api/v3/oauth/token?client_id=\(self.clientID)&client_secret=\(self.clientSecret)&code=\(code)&grant_type=authorization_code"
                    
                        
                    
                    self.performRequestGetTokenExchange(url: urlForExchangeString) { TokenExchange in
                        self.didGetTokenExchanged(tokenExchange: TokenExchange)
                    }
                
                }
                
            }
            
            authSession.presentationContextProvider = viewController as? any ASWebAuthenticationPresentationContextProviding
            
            authSession.start()
            
        }
        
    }
    
}

//Support methods
extension APIAuthen {
    
    func getTokenExchangeFromApp(codeForExchange: String) {
        let urlForExchangeString = "https://www.strava.com/api/v3/oauth/token?client_id=\(self.clientID)&client_secret=\(self.clientSecret)&code=\(codeForExchange)&grant_type=authorization_code"
        
        
        self.performRequestGetTokenExchange(url: urlForExchangeString) { TokenExchange in
            self.didGetTokenExchanged(tokenExchange: TokenExchange)
        }
    }
    
    func didGetUrlCode(url: URL){
        if let code = extractAuthorizationCode(from: url){
            let urlForExchangeString = "https://www.strava.com/oauth/token?client_id=\(self.clientID)&client_secret=\(self.clientSecret)&code=\(code)&grant_type=authorization_code"
            
  
            self.performRequestGetTokenExchange(url: urlForExchangeString) { TokenExchange in
                self.didGetTokenExchanged(tokenExchange: TokenExchange)
            }
        }
    }
    
    
    func performRequestGetTokenExchange(url: String, completion: @escaping (_ tokenExchange: TokenExchange) -> Void ) {
        APIManager.shared.requestAPI(endPoint: url, methodHTTP: .post,signatureHeader: true, optionalHeaders: nil, vc: nil) { json, sstc in
            if(sstc?.statusCode == StatusCode.SUCCESS.rawValue){
                
                guard let json = json else {
                    print("No json data")
                    return
                }
                
                completion(TokenExchange(from: json))
            }
        }
        
    }
    
    func extractAuthorizationCode(from url: URL) -> String? {
        if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
            for queryItem in queryItems {
                if queryItem.name == "code" {
                    return queryItem.value
                }
            }
        }
        return nil
    }
}


