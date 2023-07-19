//
//  Normal.swift
//  Hi Health
//
//  Created by k2 tam on 14/07/2023.
//

import Foundation

struct ItemsSection {
    let itemsList: [Item]
    var rows: Int {
        return itemsList.count
    }
}

struct Item {
    let imgUrl: URL
    let title: String
    let description: String
}
