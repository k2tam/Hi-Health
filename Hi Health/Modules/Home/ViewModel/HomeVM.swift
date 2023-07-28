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
            print("************ \(token)**************")
            
        }else{
            pushLogin(vc: vc)
        }
    }
    
    func pushLogin(vc: HomeVC){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController")
        vc.present(controller, animated: true, completion: nil)
    }
}
