//
//  AddPlantViewController.swift
//  CommonPlant
//
//  Created by 아라 on 1/18/24.
//

import UIKit

class AddPlantFirstViewController: UIViewController {
    // MARK: - UI Components
    private let searchView: UIView = {
        let view = UIView()
        return view
    }()
    private let magnifier: UIImageView = {
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
    private let searchUnderlineView: UIView = {
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
}
