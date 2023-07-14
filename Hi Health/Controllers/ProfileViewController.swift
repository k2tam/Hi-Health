//
//  ProfileViewController.swift
//  Hi Health
//
//  Created by k2 tam on 14/07/2023.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileTableView: UITableView!
    
    
    var tableProfileData = [ProfileRow]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        initVM()

        
        
        initProfileTalble()
        
    }
    
    func initVM() {
      
        
    }
    
    func initProfileTalble() {
        
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.register(UINib(nibName: K.Cells.profileCellNibName, bundle: nil), forCellReuseIdentifier: K.Cells.profileCellId)
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curRow: ProfileRow = TableData.tableData[indexPath.row]
        var cellReturn: UITableViewCell!
        
        switch curRow {
        case let .profile(profileModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.profileCellId, for: indexPath) as! InfoCell
            cell.profileName.text = "\(profileModel.firstName) \(profileModel.lastName)"
            cell.location.text = "\(profileModel.state), \(profileModel.country)"
            
            cellReturn = cell
        default:
            print("error in rendering profile table rows")
        }
        
        return cellReturn
        
    }
    
    
}

extension ProfileViewController: UITableViewDelegate {
    
}
