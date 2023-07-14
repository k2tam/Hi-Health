//
//  Table.swift
//  Hi Health
//
//  Created by k2 tam on 14/07/2023.
//

import Foundation

enum ProfileRow {
    case profile(Profile)
    case chart(Chart)
    case normal(Normal)
}


struct TableData {
    static let tableData: [ProfileRow] = [
        ProfileRow.profile(Profile(firstName: "Tam", lastName: "Bui", state: "Ho Chi Minh city", country: "VietNam", avatarUrlString: "")),
//        Row.chart(Chart(currentPeriod: "This week", distance: 17.7, time: 7, elevation: 7)),
//        Row.normal(Normal(rowTitle: "Activities")),
//        Row.normal(Normal(rowTitle: "Statistics")),
//        Row.normal(Normal(rowTitle: "Routes")),
//        Row.normal(Normal(rowTitle: "Segments")),
//        Row.normal(Normal(rowTitle: "Posts")),
//        Row.normal(Normal(rowTitle: "Gear"))

    ]
        
    
}
