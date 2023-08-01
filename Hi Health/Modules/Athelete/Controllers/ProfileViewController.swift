//
//  ProfileViewController.swift
//  Hi Health
//
//  Created by k2 tam on 14/07/2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileTableView: UITableView!
    
    //    var profileVM: FakeProfileViewModel!
    var profileVM: ProfileViewModel!
    var tableProfileData: ProfileTable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProfileVM()
        initProfileTalble()
        
    }
    
    func initProfileVM() {
        
        profileVM = ProfileViewModel()
        
        
        profileVM.fetchProfileTableData {[weak self] profileTableData in
            self?.tableProfileData = profileTableData
            
            DispatchQueue.main.async {
                self?.profileTableView.reloadData()
            }
            
        }
    }
    
    func initProfileTalble() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        profileTableView.register(UINib(nibName: K.Cells.profileCellNibName, bundle: nil), forCellReuseIdentifier: K.Cells.profileCellId)
        profileTableView.register(UINib(nibName: K.Cells.chartCellNibName, bundle: nil), forCellReuseIdentifier: K.Cells.chartCellId)
        profileTableView.register(UINib(nibName: K.Cells.signOutBtnCellNibName, bundle: nil), forCellReuseIdentifier: K.Cells.signOutCellId)
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {

        guard let tableProfileData = tableProfileData else {
            return 0
        }

        return tableProfileData.profileSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch tableProfileData.profileSections[section]{
        case let .items(itemsSection):
            return itemsSection.rows
        default:
            return 1
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableProfileData.profileSections[indexPath.section] {
        case let .profile(profileSectionModel):
            let profileInfoSectionView = tableView.dequeueReusableCell(withIdentifier: K.Cells.profileCellId) as! InfoCell
            profileInfoSectionView.profileSectionModel = profileSectionModel
            
            return profileInfoSectionView
        case let .chart(chartSectionModel):
            let chartSectionView = tableView.dequeueReusableCell(withIdentifier: K.Cells.chartCellId) as! ChartCell
            
            chartSectionView.chartCellData = chartSectionModel
            
            
            return chartSectionView
        case .signOutBtn:
            let signOutCellView = tableView.dequeueReusableCell(withIdentifier: K.Cells.signOutCellId) as! SignOutCell
            
            signOutCellView.delegate = self
            
            return signOutCellView
            
        default:
            let signOutCellView = tableView.dequeueReusableCell(withIdentifier: K.Cells.signOutCellId) as! SignOutCell
            
            signOutCellView.delegate = self
            
            return signOutCellView
        }
        
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
}

extension ProfileViewController: SignOutCellDelegate {
    func didPressSignOut() {
        self.profileVM.performSignOut()
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController")
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
        
    }
    
}
