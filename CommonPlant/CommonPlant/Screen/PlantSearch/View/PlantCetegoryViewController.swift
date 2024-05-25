//
//  PlantCetegoryViewController.swift
//  CommonPlant
//
//  Created by 이예원 on 5/21/24.
//

import UIKit
import SnapKit
import Then

class PlantCetegoryViewController: UIViewController {
    // MARK: - UI Components
    private let tableView = UITableView().then {
        $0.estimatedRowHeight = 92
        $0.separatorStyle = .none
        $0.register(PlantDictTableViewCell.self, forCellReuseIdentifier: PlantDictTableViewCell.identifier)
        $0.backgroundColor = .white
    }
    private lazy var underLineView = UIView()
    private var leadingDistance: Constraint!
    private lazy var segmentedController = UISegmentedControl().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.insertSegment(withTitle: "선호", at: 0, animated: false)
        $0.insertSegment(withTitle: "비선호", at: 1, animated: true)
        $0.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        $0.setDividerImage(UIImage(), forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray4!,
            NSAttributedString.Key.font: UIFont.bodyM2
        ], for: .normal)
        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray6!,
            NSAttributedString.Key.font: UIFont.bodyB2
        ], for: .selected)
    }
    
    // MARK: - Properties
    var navigationBackgroundColor: String?
    var selectedIndex = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setSegmentedControl()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNaviationAndStatusBarColor()
    }
    
    // MARK: - Custom Method
    private func setSegmentedControl() {
        if selectedIndex == 3 || selectedIndex == 4 {
            segmentedController.isHidden = false
        }
        segmentedController.selectedSegmentIndex = 0
        segmentedController.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        if selectedIndex == 3 {
            underLineView.backgroundColor = UIColor(red: 1, green: 0.43, blue: 0.43, alpha: 1)
        } else if selectedIndex == 4 {
            underLineView.backgroundColor = UIColor(red: 0.55, green: 0.76, blue: 0.78, alpha: 1)
        }
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        let segmentIndex = sender.selectedSegmentIndex
        let segmentWidth = segmentedController.frame.width / CGFloat(segmentedController.numberOfSegments)
        leadingDistance.update(offset: segmentWidth * CGFloat(segmentIndex))
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension PlantCetegoryViewController {
    private func configureNaviationAndStatusBarColor() {
        self.view.backgroundColor = .white
        if let backgroundColor = navigationBackgroundColor {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: backgroundColor)
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bodyB1, .foregroundColor: UIColor.gray6 as Any]
            self.navigationItem.backButtonTitle = ""
        }
    }
    
    private func setConstraints() {
        [segmentedController, underLineView, tableView].forEach {
            view.addSubview($0)
        }
        
        segmentedController.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(55)
        }
        
        underLineView.snp.makeConstraints { make in
            make.bottom.equalTo(segmentedController.snp.bottom)
            make.height.equalTo(2)
            leadingDistance = make.leading.equalTo(segmentedController.snp.leading).constraint
            make.width.equalTo(segmentedController.snp.width).multipliedBy(1.0 / CGFloat(segmentedController.numberOfSegments))
        }
        
        tableView.snp.makeConstraints {
            if selectedIndex == 3 || selectedIndex == 4 {
                $0.top.equalTo(segmentedController.snp.bottom).offset(16)
            } else {
                $0.top.equalToSuperview().offset(16)
            }
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
