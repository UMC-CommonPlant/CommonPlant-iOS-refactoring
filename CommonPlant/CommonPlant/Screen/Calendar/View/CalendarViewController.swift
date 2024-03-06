//
//  CalendarViewController.swift
//  CommonPlant
//
//  Created by 아라 on 3/6/24.
//

import UIKit

class CalendarViewController: UIViewController {
    // MARK: - UI Components
    private let scrollView: UIView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    private let contentView = UIView()
    private let calendarView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    private let selectedMonthLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyB1
        label.textColor = .gray6
        return label
    }()
    private let wholeMonthButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "NextMonth")
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        button.configuration = config
        return button
    }()
    private let previousButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "PreMonth")
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        button.configuration = config
        return button
    }()
    private let nextButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "NextMonth")
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        button.configuration = config
        return button
    }()
    private let weekStackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.distribution = .equalSpacing
        ["일", "월", "화", "수", "목", "금", "토"].forEach {
            let label = UILabel()
            label.text = $0
            label.font = .bodyM3
            label.textColor = .gray5
            label.textAlignment = .center
            
            view.addArrangedSubview(label)
            
            label.snp.makeConstraints { make in
                make.width.height.equalTo(40)
            }
        }
        return view
    }()
    private let calendarCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 4
        flowLayout.itemSize = CGSize(width: 40, height: 40)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.isScrollEnabled = false
        
        return view
    }()
    private let placeCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: 40, height: 40)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        flowLayout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        view.isScrollEnabled = true
        
        return view
    }()
    private let plantCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: 106, height: 124)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        flowLayout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        view.isScrollEnabled = true
        
        return view
    }()
    private let messageView: UIView = {
        let view = UIView()
        return view
    }()
    private let firstMetView: UIView = {
        let view = UIView()
        view.backgroundColor = .sunflowerYellow
        return view
    }()
    private let firstMetLabel: UILabel = {
        let label = UILabel()
        label.text = "처음 데려온 날이에요"
        label.font = .bodyB3
        label.textColor = .activeOrange
        return label
    }()
    private let waterView: UIView = {
        let view = UIView()
        view.backgroundColor = .aquaBlue
        return view
    }()
    private let waterLabel: UILabel = {
        let label = UILabel()
        label.text = "물 주는 날이에요"
        label.font = .bodyB3
        label.textColor = .activeBlue
        return label
    }()
    private let divisionView: UIView = {
        let view = UIView()
        view.backgroundColor = .seaGreen
        return view
    }()
    private let memoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 16, right: 20)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        view.isScrollEnabled = false
        
        return view
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
