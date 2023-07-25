//
//  File.swift
//  Hi Health
//
//  Created by TaiVC on 7/25/23.
//

import UIKit

class ActivitiesVC: UIViewController{
    
    var viewModel: ActivitiesVM = ActivitiesVM()
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var btnPerson: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        viewModel.fetchListActivities(vc: self)
    }
    
}
