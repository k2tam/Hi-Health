//
//  MyHomeVC.swift
//  Hi Health
//
//  Created by TaiVC on 7/21/23.
//

import Foundation
import UIKit


class HomeVM {
    let defaults = UserDefaults.standard
    
    func fetchData(){
        
    }
    
    func checkLogin(vc: HomeVC){
        if let token = defaults.string(forKey: K.UserDefaultKeys.accessToken){
            print(token)
            
        }else{
            pushLogin(vc: vc)
        }
    }
    
    func pushLogin(vc: HomeVC){
        guard let vcPopup = UIStoryboard(name: "Main", bundle: Bundle(for: HomeVM.self)).instantiateViewController(withIdentifier: "ViewController") as? ViewController else {return}
        vc.modalPresentationStyle = .overFullScreen
        vc.present(vcPopup, animated: false)
    }
}
