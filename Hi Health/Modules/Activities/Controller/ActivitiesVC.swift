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
                viewModel.fetchDataMapRun(vc: self, id: id, callback: {data in
                    self.viewModel.getImageRun(data: LatLngModel(json: data, id: indexPath.row), id: indexPath.row, callback: { data in
                        self.imageArray[indexPath.row] = data
                        print(self.imageArray.count)
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    })
                })
            }
            cell.setupCell(id: data.id, moving_Time: viewModel.secondsToHoursMinutesSeconds(seconds: Double(data.movingTime)), Distance: viewModel.getDistance(distance: Int(data.distance)), startDateLocal: viewModel.formatISO8601Date(dateString: data.startDateLocal)!, name: data.name,avatar: viewModel.getNameavatar().last!,namePerson: viewModel.getNameavatar().first!,paces: viewModel.getPace(time: Double(data.movingTime), distance: Double(data.distance)), image: imageArray[indexPath.item])
            cell .selectionStyle = .none

            return cell
        default:
            return UITableViewCell()
        }
    }
}

