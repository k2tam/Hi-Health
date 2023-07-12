////
////  APIService.swift
////  Hi Health
////
////  Created by k2 tam on 12/07/2023.
////
//
import Foundation
import AuthenticationServices


class APIService {
    func performRequest(url: URL, completion: @escaping (_ authenModel: AuthenModel) -> Void ) {
        var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let safeData = data {
                if let authenModel = self.parseJson(from: safeData){
                    completion(authenModel)
                    
                }
            }
        }
        
        task.resume()
        
    }
    
    
    func parseJson(from data: Data) -> AuthenModel? {
        let decoder = JSONDecoder()
        
        do {
            let authenModel = try decoder.decode(AuthenModel.self, from: data)
            
            return authenModel
            
        }catch{
            print(error.localizedDescription)
        }
        
        return nil
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
    
    func authorize(viewController: UIViewController) {
        let clientID = "110470"
        let clientSecret = "d69b84d8f46f26a64415c905099741eaeeeb9ee0"
        let redirectUri = "myapp://myapp.com"
        let scope = "activity:read"
        
        
        
        let appOAuthUrlStravaSchemeString =  "strava://oauth/mobile/authorize?client_id=\(clientID)&redirect_uri=\(redirectUri)&response_type=code&approval_prompt=auto&scope=\(scope)&state=test"
        
        let webOAuthUrlString =  "https://www.strava.com/oauth/mobile/authorize?client_id=\(clientID)&redirect_uri=\(redirectUri)&response_type=code&approval_prompt=auto&scope=\(scope)&state=test"
        
        
        
        guard let appOAuthUrlStravaScheme = URL(string: appOAuthUrlStravaSchemeString) else { return }
        guard let webOAuthUrl = URL(string: webOAuthUrlString) else {return}
        
        
//        if(UIApplication.shared.canOpenURL(appOAuthUrlStravaScheme)){
//            UIApplication.shared.open(appOAuthUrlStravaScheme, options: [:]) { isSuccess in
//                if isSuccess {
//
//                }
//            }
//
//        }  else {
            let authSession: ASWebAuthenticationSession
            
            authSession = ASWebAuthenticationSession(url: webOAuthUrl, callbackURLScheme: "myapp"  ) { url, error in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let url = url else {return}
                
                
                //Get code for exchanging
                if let code = self.extractAuthorizationCode(from: url){
                    let urlForExchangeString = "https://www.strava.com/oauth/token?client_id=\(clientID)&client_secret=\(clientSecret)&code=\(code)&grant_type=authorization_code"
                    
                    guard let urlForExchange = URL(string: urlForExchangeString) else {
                        return
                    }
                    
                    self.performRequest(url: urlForExchange) { authenModel in
                        print(authenModel.accessToken!)
                        print(authenModel.refreshToken!)
                    }
                }
                
                
            }
            
            
            authSession.presentationContextProvider = viewController as! any ASWebAuthenticationPresentationContextProviding
            
            authSession.start()
            
            
            
        }
        
        
        
    }

