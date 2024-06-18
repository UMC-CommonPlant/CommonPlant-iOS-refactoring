//
//  FriendRequestViewController.swift
//  CommonPlant
//
//  Created by 이예원 on 6/17/24.
//

import UIKit
import Then
import SnapKit

class FriendRequestViewController: UIViewController {
    // MARK: - UI Components
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setContstraints()
    }
}

extension FriendRequestViewController {
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "장소 친구 요청"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bodyB1, .foregroundColor: UIColor.gray6 as Any]
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backButtonTitle = ""
    }
    
    private func setContstraints() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
