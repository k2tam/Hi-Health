//
//  ViewController.swift
//  Hi Health
//
//  Created by k2 tam on 12/07/2023.
//

import UIKit
import AuthenticationServices


class ViewController: UIViewController {

    
    let apiService = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiService.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleURLCode(_:)), name: Notification.Name("GetURLCode"), object: nil)

    }
    
    @objc func handleURLCode(_ notification: Notification) {
        if let url = notification.userInfo?["urlCode"] as? URL {
            // Process the URL as needed
            apiService.didGetUrlCode(url: url)
        }
    }

    @IBAction func loginBtn(_ sender: UIButton) {
        apiService.authorize(viewController: self)
        
    }
}

extension ViewController : ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window!
    }
}


extension ViewController: APIServiceDelegate {
    func didSuccessAuthorized() {
        self.performSegue(withIdentifier: K.segueLoginToHome, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
}

