//
//  ChartCell.swift
//  Hi Health
//
//  Created by k2 tam on 16/07/2023.
//

import UIKit
import SwiftUI
import Charts
import TinyConstraints


class ChartCell: UITableViewCell {
    
    @IBOutlet weak var activitiesCollectionView: UICollectionView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var elevationLabel: UILabel!
    @IBOutlet weak var actiChartView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var chartView = ChartView()

    private var chartVM: ChartViewModel!

    
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
        guard let latestActivityTypeToDisplay =  groupedActivities?[actiIndex].descOrderedActivites.first else {
            print("No latestActivityTypeToDisplay")
            return
        }
        
        let actiModels = groupedActivities?[actiIndex].ascOrderedActivites.map { activity in
                   return activity
            
        }

        chartVM.updateChartData(activities: groupedActivities?[actiIndex].ascOrderedActivites ?? [])
        chartView.actiModels = actiModels
        updateActiLabel(activity: latestActivityTypeToDisplay)
        

    }
    
    func updateActiLabel(activity: Activity) {
        distanceLabel.text = activity.distanceString
        timeLabel.text = activity.timeString
        dateLabel.text = activity.formattedStartDate
    }
    
    
    

    func initActiCollectionView() {
        activitiesCollectionView.dataSource = self
        activitiesCollectionView.delegate = self

        activitiesCollectionView.register(UINib(nibName: K.Cells.actiBtnCellNibName, bundle: nil), forCellWithReuseIdentifier: K.Cells.actiBtnCellId)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initActiCollectionView()
        setUpChart()
    }

    
    private var currentChartView: UIView?
    
    
    
    func setUpChart() {
        chartVM = ChartViewModel()
        chartVM.delegate = self
        chartView.customDelegate = self

        actiChartView.addSubview(chartView)
        chartView.edgesToSuperview()
        
    }
}

extension ChartCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupedActivities?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let actiBtnCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Cells.actiBtnCellId, for: indexPath) as! ActiBtnCell

        let activityTypeModel = groupedActivities?[indexPath.row]

        actiBtnCell.actiBtnLabel.text = activityTypeModel?.typeActivity ?? ""
        actiBtnCell.actiBtnIcon.image = activityTypeModel?.activityIcon ?? UIImage()


        return actiBtnCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{

            return CGSize(width: 100, height: 30)
        }
}

extension ChartCell: ChartViewModelDelegate {
    func didGetNewChartData(barChartData: Charts.BarChartData, actiModelsList: [Activity]) {
        chartView.chartData = barChartData
    }


}


extension ChartCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        updateUI(actiIndex: indexPath.item)
        
    }
}

extension ChartCell: CustomChartViewDelegate {
    func didSelectABar(activity: Activity) {
        updateActiLabel(activity: activity)
    }
    
    
}

