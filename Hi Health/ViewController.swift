//
//  ViewController.swift
//  Hi Health
//
//  Created by k2 tam on 12/07/2023.
//

import UIKit
import AuthenticationServices


class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func loginBtn(_ sender: UIButton) {
        APIService().authorize(viewController: self)
    }
    
    
}

extension ViewController : ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window!
    }
}



