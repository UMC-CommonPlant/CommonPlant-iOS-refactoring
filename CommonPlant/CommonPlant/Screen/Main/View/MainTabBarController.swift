//
//  MainTabBarController.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/07/06.
//

import UIKit

class MainTabBarController: UITabBarController {
    // MARK: - Properties
    static var tabBarHeight = 98
    private var imageInset = 13
    
    // MARK: - Life Cycle
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
        if self.view.safeAreaInsets.bottom == 0 {
            MainTabBarController.tabBarHeight = 64
        }
        tabFrame.size.height = CGFloat(MainTabBarController.tabBarHeight)
        tabFrame.origin.y = self.view.frame.size.height - CGFloat(MainTabBarController.tabBarHeight)
        self.tabBar.frame = tabFrame
    }

    // MARK: - UI
    private func configureUI() {
        tabBar.backgroundColor = .white
        let plantSearchViewController = UINavigationController(rootViewController: PlantSearchViewController())
        let calenderViewController = PlantSearchViewController()
        let mainViewController = UINavigationController(rootViewController: MainViewController())
        let profileViewController = MyPageViewController()
        
        plantSearchViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "info"), selectedImage: UIImage(named: "infoActive"))
        calenderViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "calendar"), selectedImage: UIImage(named: "calendarActive"))
        mainViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "main"), selectedImage: UIImage(named: "mainActive"))
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "profile"), selectedImage: UIImage(named: "profileActive"))
        
        if self.view.safeAreaInsets.bottom == 0 {
            imageInset = 5
        }
        
        plantSearchViewController.tabBarItem.imageInsets = UIEdgeInsets(top: CGFloat(imageInset), left: 0, bottom: -CGFloat(imageInset), right: 0)
        calenderViewController.tabBarItem.imageInsets = UIEdgeInsets(top: CGFloat(imageInset), left: 0, bottom: -CGFloat(imageInset), right: 0)
        mainViewController.tabBarItem.imageInsets = UIEdgeInsets(top: CGFloat(imageInset), left: 0, bottom: -CGFloat(imageInset), right: 0)
        profileViewController.tabBarItem.imageInsets = UIEdgeInsets(top: CGFloat(imageInset), left: 0, bottom: -CGFloat(imageInset), right: 0)
        
        self.viewControllers = [plantSearchViewController, calenderViewController, mainViewController, profileViewController]
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
