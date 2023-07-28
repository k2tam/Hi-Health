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

protocol APIServiceDelegate {
    func didSuccessAuthorized()
    
}

class APIAuthen {

    
    static var shared: APIAuthen = APIAuthen()

    let clientID = "108189"
    let clientSecret = "3abb1e1776afd45f08ec908133f11f2eaf2168f2"
    let redirectUri = "myapp://developers.strava.com"
    let scope = "read_all,activity:read_all,activity:write"
    
    let defaults = UserDefaults.standard
    var delegate: APIServiceDelegate?
    
    public func performDeauthorizeRequest(accessToken: String) {
        let urlString = "https://www.strava.com/oauth/deauthorize"

        let url = URL(string: urlString)

        var request = URLRequest(url: url!)
        request.httpMethod = "POST"

        let bodyParameters = "access_token=\(accessToken)"
        request.httpBody = bodyParameters.data(using: .utf8)

        let session = URLSession.shared
        let task = session.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error: \(error)")
                // Handle the error accordingly
                return
            }

        }

        task.resume()
    }
    
    func didGetTokenExchanged(tokenExchange: TokenExchange) {
        TokenDataManager.shared.saveData(tokenExchange: tokenExchange)

        DispatchQueue.main.async {
            self.delegate?.didSuccessAuthorized()
        }
    }
    
    func getNewTokenExchange(refreshToken: String) {
        let urlString = "https://www.strava.com/oauth/token?grant_type=refresh_token&client_id=\(clientID)&client_secret=\(clientSecret)&refresh_token=\(refreshToken)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        performRequestGetTokenExchange(url: urlString) { tokenExchange in
            
            TokenDataManager.shared.saveData(tokenExchange: tokenExchange)
        }
        
        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        let expiresAtTimestamp: TimeInterval = Double(TokenDataManager.shared.getTokenExpiresAt())
        // Get the current timestamp
        
        let currentTimestamp = Date().timeIntervalSince1970
        

        // Compare the expiration timestamp with the current timestamp
        if  expiresAtTimestamp != 0 {
            if expiresAtTimestamp < currentTimestamp {
                getNewTokenExchange(refreshToken: String(TokenDataManager.shared.getRefreshToken()))
               
            } else {
                delegate?.didSuccessAuthorized()

            }
        }
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
                    
                        
                    guard let urlForExchange = URL(string: urlForExchangeString) else {
                        return
                    }
                    
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
        
        guard let urlForExchange = URL(string: urlForExchangeString) else {
            return
        }
        
        
        self.performRequestGetTokenExchange(url: urlForExchangeString) { TokenExchange in
            self.didGetTokenExchanged(tokenExchange: TokenExchange)
        }
    }
    
    func didGetUrlCode(url: URL){
        if let code = extractAuthorizationCode(from: url){
            let urlForExchangeString = "https://www.strava.com/oauth/token?client_id=\(self.clientID)&client_secret=\(self.clientSecret)&code=\(code)&grant_type=authorization_code"
            
            guard let urlForExchange = URL(string: urlForExchangeString) else {
                return
            }
            
            
            self.performRequestGetTokenExchange(url: urlForExchangeString) { TokenExchange in
                self.didGetTokenExchanged(tokenExchange: TokenExchange)
            }
        }
    }
    
    
    func performRequestGetTokenExchange(url: String, completion: @escaping (_ tokenExchange: TokenExchange) -> Void ) {
        
//        var urlString: String!
//        do {
//            urlString = try String(contentsOf: url)
//        }catch {
//            print("Failed to convert url to url String")
//        }
        
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


