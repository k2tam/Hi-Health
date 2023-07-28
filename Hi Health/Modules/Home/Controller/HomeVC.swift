//
//  HomeVC.swift
//  Hi Health
//
//  Created by TaiVC on 7/17/23.
//

import UIKit

class HomeVC: UIViewController {

    var viewModel: HomeVM = HomeVM()
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        setupViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
    }
    func setupViewModel(){
        viewModel.checkLogin(vc: self)
    }
    
    
    
    
    
    
   
}
