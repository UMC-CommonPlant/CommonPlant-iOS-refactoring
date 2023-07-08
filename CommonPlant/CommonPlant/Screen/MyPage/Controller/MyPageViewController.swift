//
//  MyPageViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/08.
//

import UIKit

class MyPageViewController: UIViewController {
    
    let rootView = MyPageView()
    let settingView = SettingView()
    
    override func loadView() {
        self.view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
