//
//  ChartCell.swift
//  Hi Health
//
//  Created by k2 tam on 16/07/2023.
//

import UIKit

class ChartCell: UITableViewCell {
    
    @IBOutlet weak var activitiesCollectionView: UICollectionView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var elevationLabel: UILabel!
    @IBOutlet weak var chartView: UIView!
    
    var groupedActivities: [SpecificActivity]?

    var chartCellData: ChartSection? {
        didSet {
            // Update UI based on the new value of chartCellData
            self.groupedActivities =  chartCellData?.groupedActivies
            if !groupedActivities!.isEmpty {
                updateUI(actiIndex: 0)

            }
        }
    }
    

    private func updateUI(actiIndex: Int) {
        // Use chartCellData to update the UI elements in the cell
        let latestActivityTypeToDisplay =  groupedActivities?[actiIndex].orderedActivites.first

        distanceLabel.text = latestActivityTypeToDisplay?.distanceString
        timeLabel.text = latestActivityTypeToDisplay?.timeString

    }

    func initActiCollectionView() {
        activitiesCollectionView.dataSource = self
        activitiesCollectionView.delegate = self


        activitiesCollectionView.register(UINib(nibName: K.Cells.actiBtnCellNibName, bundle: nil), forCellWithReuseIdentifier: K.Cells.actiBtnCellId)
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        initActiCollectionView()
        
        
        
    }
    
}

extension ChartCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupedActivities?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {


        let actiBtnCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Cells.actiBtnCellId, for: indexPath) as! ActiBtnCell

//        let activityModel = activitesData[indexPath.row]
        let activityTypeModel = groupedActivities?[indexPath.row]
    

        actiBtnCell.actiBtnLabel.text = activityTypeModel?.typeActivity ?? ""
        actiBtnCell.actiBtnIcon.image = activityTypeModel?.activityIcon ?? UIImage()


        return actiBtnCell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{

            return CGSize(width: 100, height: 30)
        }


}

extension ChartCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        updateUI(actiIndex: indexPath.item)
        
    }
}


