//
//  TabItem.swift
//  Hi Health
//
//  Created by TaiVC on 7/17/23.
//

import UIKit

enum TabItem{
    case home
    case challenge
    case activies
    
    var viewController: UIViewController{
        switch self {
        case .home:
            return UINavigationController(rootViewController: HomeVC())
        case .challenge:
            return UIViewController()
        case .activies:
            return UIViewController()
        }
    }
    
    var icon: UIImage {
        switch self {
        case .home:
            return UIImage(named: "tabbar_item_home") ?? UIImage()
        case .challenge:
            return UIImage(named: "tabbar_item_home") ?? UIImage()
        case .activies:
            return UIImage(named: "tabbar_item_home") ?? UIImage()
        }
    }
    var iconSelected: UIImage {
        switch self {
        case .home:
            return UIImage(named: "tabbar_item_home_selected") ?? UIImage()
        case .challenge:
            return UIImage(named: "tabbar_item_home_selected") ?? UIImage()
        case .activies:
            return UIImage(named: "tabbar_item_home_selected") ?? UIImage()
        }
    }
    var displayTitle: String {
        switch self {
        case .home:
            return "Home"
        case .challenge:
            return "Challenge"
        case .activies:
            return "Activies"
        }
    }
}

