//
//  MainTabBarController.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/07/06.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBorder()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.selectedIndex = 2
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = 98
        tabFrame.origin.y = self.view.frame.size.height - 98
        self.tabBar.frame = tabFrame
    }
    
    private func configureUI() {
        tabBar.backgroundColor = .white
        let infoViewController = ViewController()
        let calenderViewController = MainViewController()
        let mainViewController = UINavigationController(rootViewController: MainViewController())
        let profileViewController = MainViewController()
        
        infoViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "info"), selectedImage: UIImage(named: "infoActive"))
        calenderViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "calendar"), selectedImage: UIImage(named: "calendarActive"))
        mainViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "main"), selectedImage: UIImage(named: "mainActive"))
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "profile"), selectedImage: UIImage(named: "profileActive"))
        
        infoViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 13, left: 0, bottom: -13, right: 0)
        calenderViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 13, left: 0, bottom: -13, right: 0)
        mainViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 13, left: 0, bottom: -13, right: 0)
        profileViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 13, left: 0, bottom: -13, right: 0)
        
        
        self.viewControllers = [infoViewController, calenderViewController, mainViewController, profileViewController]
    }
    
    private func configureBorder() {
        let topBorderHeight: CGFloat = 1
        let topBorderColor = UIColor.gray2?.cgColor
        
        let borderLayer = CALayer()
        borderLayer.frame = CGRect(x: 0 , y: 0, width: tabBar.bounds.width, height: topBorderHeight)
        borderLayer.backgroundColor = topBorderColor
        
        tabBar.layer.addSublayer(borderLayer)
    }
}


import SwiftUI

struct TabBarControllerPreview: PreviewProvider {
    static var previews: some View {
        MainTabBarController().toPreview()
    }
}
