//
//  ProfileViewController.swift
//  Hi Health
//
//  Created by k2 tam on 14/07/2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileTableView: UITableView!
    
    var profileVM: ProfileViewModel!
    var apiAuthen: APIAuthen!
    var tableProfileData: ProfileTable!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProfileVM()
        initProfileTalble()
        
    }
    
    func initProfileVM() {
        profileVM = ProfileViewModel(apiService: apiAuthen)
        profileVM.fetchProfileTableData { profileTableData in
            self.tableProfileData = profileTableData
            self.profileTableView.reloadData()
        }
        
    }
    
    func initProfileTalble() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        
        
        profileTableView.register(UINib(nibName: K.Cells.profileCellNibName, bundle: nil), forCellReuseIdentifier: K.Cells.profileCellId)
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableProfileData.profileSections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableProfileData.profileSections[section]{
        case let .items(itemsSection):
            return itemsSection.rows
        default:
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch tableProfileData.profileSections[section] {
        case let .profile(profileSectionModel):
            let profileInfoSectionView = tableView.dequeueReusableCell(withIdentifier: K.Cells.profileCellId) as! InfoCell
            profileInfoSectionView.displayNameLabel.text = profileSectionModel.profileNameDisplay
            profileInfoSectionView.locationLabel.text = profileSectionModel.userLocation
            
            return profileInfoSectionView
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: K.Cells.profileCellId)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let curRow: ProfileRow = TableData.tableData[indexPath.row]
    //        var cellReturn: UITableViewCell!
    //
    //        switch curRow {
    //        case let .profile(profileModel):
    //            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.profileCellId, for: indexPath) as! InfoCell
    //            cell.profileName.text = "\(profileModel.firstName) \(profileModel.lastName)"
    //            cell.location.text = "\(profileModel.state), \(profileModel.country)"
    //
    //            cellReturn = cell
    //        default:
    //            print("error in rendering profile table rows")
    //        }
    //
    //        return cellReturn
    //
    //    }
    
    
    
    
}

extension ProfileViewController: UITableViewDelegate {
    
}
