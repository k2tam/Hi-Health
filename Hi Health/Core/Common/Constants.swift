//
//  Constants.swift
//  Hi Health
//
//  Created by k2 tam on 13/07/2023.
//

import Foundation

struct K {
    
    
    static let segueLoginToHome = "LoginToHome"
    
    struct UserDefaultKeys {
        static let athleteID = "athleteId"
        static let scope = "scope"
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let expiresAt = "expiresAt"
        static let athleteModel = "athleteModel"
    }

    struct Cells {
        static let profileCellNibName = "InfoCell"
        static let profileCellId = "ProfileCellIdentifier"
        static let chartCellNibName = "ChartCell"
        static let chartCellId = "ChartCellIdentifier"
        static let actiBtnCellNibName = "ActiBtnCell"
        static let actiBtnCellId = "activityBtnCellId"
        static let signOutBtnCellNibName = "SignOutCell"
        static let signOutCellId = "SignOutCellId"
    }
    
    
    static let monthTubles = [(label: "Jan", value: 1),(label: "Feb", value: 2),(label: "Mar", value: 3),(label: "Apr", value: 4),(label: "May", value: 5),(label: "Jun", value: 6),(label: "Jul", value: 7),(label: "Aug", value: 8),(label: "Sep", value: 9),(label: "Oct", value: 10),(label: "Nov", value: 11),(label: "Dec", value: 12)]
    
}
