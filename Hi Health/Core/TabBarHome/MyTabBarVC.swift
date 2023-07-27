//
//  MyTabBarVC.swift
//  Hi Health
//
//  Created by TaiVC on 7/17/23.
//

import UIKit

class MyTabBarVC: UITabBarController{
    var mTabbar: CustomTabBar!
    var tabBarHeight: CGFloat = 120
    override func viewDidLoad() {
        view.backgroundColor = .darkGray
        self.loadTabBar()
    }
    func loadTabBar() {
        self.setupCustomTabBar(){ controllers in
            self.viewControllers = controllers
        }
        self.selectedIndex = 0
    }
    func selectTab(selectTabBar: Int = 0) {
        DispatchQueue.main.async {
            self.selectedIndex = selectTabBar
            switch selectTabBar {
            case 0:
                self.mTabbar.oneTap()
            case 1:
                self.mTabbar.twoTap()
            case 2:
                self.mTabbar.threeTap()
            default:
                self.mTabbar.oneTap()
            }
        }
    }
    
    private func setupCustomTabBar(completion: @escaping ([UIViewController]) -> Void){
        tabBar.isHidden = true
        
        let frame = CGRect(x: tabBar.frame.origin.x, y: tabBar.frame.origin.x, width: tabBar.frame.width, height: tabBarHeight)
        
        mTabbar = CustomTabBar(frame: frame)
        mTabbar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mTabbar)
        NSLayoutConstraint.activate([
            self.mTabbar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            self.mTabbar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            self.mTabbar.widthAnchor.constraint(equalTo: tabBar.widthAnchor),
            self.mTabbar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor),
            self.mTabbar.heightAnchor.constraint(equalToConstant: tabBarHeight)
        ])
        var isUpStore = false
        mTabbar.configs(delegate: self, isUpStore: isUpStore, onSuccess: {
            controllers in
            self.view.layoutIfNeeded()
            completion(controllers)
        })
    }
}
extension MyTabBarVC: MyTabbarDelegate{
    func didSelectItem(_ item: TabItem) {
        switch item {
        case .home:
            self.selectedIndex = 0
            break
        case .challenge:
            self.selectedIndex = 1
            break
        case .activies:
            self.selectedIndex = 3
            break
        }
    }
    
}
