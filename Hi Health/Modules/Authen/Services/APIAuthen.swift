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
    let clientID = "110470"
    let clientSecret = "d69b84d8f46f26a64415c905099741eaeeeb9ee0"
    let redirectUri = "myapp://developers.strava.com"
    let scope = "read_all,activity:read_all,activity:write"
    
    let defaults = UserDefaults.standard
    var delegate: APIServiceDelegate?
    
    
    
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
        
        performRequestGetTokenExchange(url: url) { tokenExchange in
            
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
                    
                    self.performRequestGetTokenExchange(url: urlForExchange) { TokenExchange in
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
        
        
        self.performRequestGetTokenExchange(url: urlForExchange) { TokenExchange in
            self.didGetTokenExchanged(tokenExchange: TokenExchange)
        }
    }
    
    func didGetUrlCode(url: URL){
        if let code = extractAuthorizationCode(from: url){
            let urlForExchangeString = "https://www.strava.com/oauth/token?client_id=\(self.clientID)&client_secret=\(self.clientSecret)&code=\(code)&grant_type=authorization_code"
            
            guard let urlForExchange = URL(string: urlForExchangeString) else {
                return
            }
            
            
            self.performRequestGetTokenExchange(url: urlForExchange) { TokenExchange in
                self.didGetTokenExchanged(tokenExchange: TokenExchange)
            }
        }
    }
    
    
    func performRequestGetTokenExchange(url: URL, completion: @escaping (_ tokenExchange: TokenExchange) -> Void ) {
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
                let tokenExchange = self.parseJsonAuthenData(from: safeData)
                completion(tokenExchange)
            }
        }
        
        task.resume()
        
    }
    
    
    func parseJsonAuthenData(from data: Data) -> TokenExchange {
        let json = JSON(data)
        
        return TokenExchange(from: json)
        
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


