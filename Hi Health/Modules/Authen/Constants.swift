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
    }

    struct Cells {
        static let profileCellNibName = "InfoCell"
        static let profileCellId = "ProfileCellIdentifier"
        static let chartCellNibName = "ChartCell"
        static let chartCellId = "ChartCellIdentifier"
        static let actiBtnCellNibName = "ActiBtnCell"
        static let actiBtnCellId = "activityBtnCellId"
    }
}
