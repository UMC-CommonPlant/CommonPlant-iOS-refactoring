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
        setContstraints()
    }
}

extension FriendRequestViewController {
    func setContstraints() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
