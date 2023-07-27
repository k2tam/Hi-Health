//
//  CustomTabBar.swift
//  Hi Health
//
//  Created by TaiVC on 7/17/23.
//

import UIKit

protocol MyTabbarDelegate: AnyObject {
    func didSelectItem(_ item: TabItem)
}

class CustomTabBar: UIView{
    
    var items: [TabItem] = [.home, .challenge, .activies]
   
    weak var mDelegate:MyTabbarDelegate?
    
    @IBOutlet var ContentView: UIView!
    
    @IBOutlet weak var imageTabbar: UIImageView!
    
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var textOne: UILabel!
    
    @IBOutlet weak var imageTwo: UIButton!
    @IBOutlet weak var textTwo: UILabel!
    
    @IBOutlet weak var imageThree: UIImageView!
    @IBOutlet weak var textThree: UILabel!
    
    
    @IBOutlet weak var viewone: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewThree: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    func configs(delegate:MyTabbarDelegate, isUpStore:Bool, onSuccess: ((_ controllers: [UIViewController])->Void)){
        self.mDelegate = delegate
        self.layoutSubviews()
        
        var controllers = [UIViewController]()
        if let homeItem = items.first(where: { $0 == .home}) {
            controllers.append(homeItem.viewController)//add Home
        }

        if let homeItem = items.first(where: { $0 == .activies}) {
            controllers.append(homeItem.viewController)// add activies
        }
        if let homeItem = items.first(where: { $0 == .challenge}) {
            controllers.append(homeItem.viewController)// add challenge
        }
        onSuccess(controllers)
    }
    private func setupView(){
        Bundle.main.loadNibNamed("CustomTabBar", owner: self, options: nil)
        self.addSubview(ContentView)
        ContentView.frame = self.bounds
        ContentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        imageTwo.layer.cornerRadius = imageOne.frame.width/2
        
        imageOne.image = items[0].iconSelected
        textOne.text = items[0].displayTitle
        viewone.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(oneTap)))
        
        imageTwo.setImage( items[1].icon, for: .normal)
        textTwo.text = items[1].displayTitle
        viewTwo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(twoTap)))
        imageTwo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(twoTap)))
        
        imageThree.image = items[2].icon
        textThree.text = items[2].displayTitle
        viewThree.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(threeTap)))
    }
    
    @objc func oneTap(){
        imageThree.image = items[2].icon
        textThree.textColor = .gray
        
        imageTwo.setImage( items[1].icon, for: .normal)
        textTwo.textColor = .gray
        
        imageOne.image = items[0].iconSelected
        textOne.textColor = UIColor(red: 0.27, green: 0.394, blue: 0.929, alpha: 1)
        self.mDelegate?.didSelectItem(items[0])
    }
    @objc func twoTap(){
        imageOne.image = items[0].icon
        textOne.textColor = .gray
        self.mDelegate?.didSelectItem(items[0])
        
        imageThree.image = items[2].icon
        textThree.textColor = .gray
        
        imageTwo.setImage( items[1].iconSelected, for: .normal)
        textTwo.textColor = UIColor(red: 0.27, green: 0.394, blue: 0.929, alpha: 1)
        self.mDelegate?.didSelectItem(items[1])
    }
    @objc func threeTap(){
        imageOne.image = items[0].icon
        textOne.textColor = .gray
        self.mDelegate?.didSelectItem(items[0])
        
        imageTwo.setImage( items[1].icon, for: .normal)
        textTwo.textColor = .gray
        
        imageThree.image = items[2].iconSelected
        textThree.textColor = UIColor(red: 0.27, green: 0.394, blue: 0.929, alpha: 1)
        self.mDelegate?.didSelectItem(items[2])
    }
   
}
