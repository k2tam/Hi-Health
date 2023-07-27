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
    
    var imageArray: [Int:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI(){
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "CustomActivitiesTblCell", bundle: nil), forCellReuseIdentifier: "CustomActivitiesTblCell")
        
        viewModel.actionBindingData = { [self] in
            tableView.reloadData()
        }
        viewModel.actionCode = { [self] in
            tableView.reloadData()
        }
        
        if(viewModel.getTotalActivities < 1){
            viewModel.fetchListActivities(vc: self)
        }
    }
    
}
extension ActivitiesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTotalActivities
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomActivitiesTblCell") as! CustomActivitiesTblCell
            let data = viewModel.getActivitiesInfo(atIndex: indexPath.item)
            cell.callbackidImge = { [self] id in
                viewModel.fetchDataMapRun(vc: self, id: id, callback: {
                    self.viewModel.getImageRun(callback: { data in
                        self.imageArray[indexPath.item] = data
                        print(self.imageArray.count)
                        tableView.reloadData()
                    })
                })
            }
            cell.setupCell(data: data, image: imageArray[indexPath.item])
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    
}
