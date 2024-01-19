//
//  AddPlantViewController.swift
//  CommonPlant
//
//  Created by 아라 on 1/18/24.
//

import UIKit
import SnapKit

class AddPlantFirstViewController: UIViewController {
    // MARK: - UI Components
    private let searchView: UIView = {
        let view = UIView()
        return view
    }()
    private let magnifierImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Search")
        return view
    }()
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "식물을 입력해주세요"
        tf.font = .bodyM1
        tf.textColor = .black
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray1
        return view
    }()
    private let searchResultTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.rowHeight = 92
        return view
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setConstraints() {
        [searchView, searchResultTableView].forEach {
            view.addSubview($0)
        }
        
        [magnifierImageView, searchTextField, underlineView].forEach {
            searchView.addSubview($0)
        }
        
        searchView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(64)
        }
        
        magnifierImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(magnifierImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
        }
        
        underlineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        searchResultTableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
