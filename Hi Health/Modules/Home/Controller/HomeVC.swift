//
//  HomeVC.swift
//  Hi Health
//
//  Created by TaiVC on 7/17/23.
//

import UIKit

class HomeVC: UIViewController {

    var viewModel: HomeVM!
    
    
    @IBOutlet weak var text: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
       
    }
    func setupViewModel(){
        viewModel = HomeVM()
        viewModel.checkLogin(vc: self)
    }
    
    
    
    
    
    
   
}
