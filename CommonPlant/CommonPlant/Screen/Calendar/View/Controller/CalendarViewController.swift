//
//  CalendarViewController.swift
//  CommonPlant
//
//  Created by 아라 on 3/6/24.
//

import UIKit
import SnapKit

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
        return view
    }()
    private let wholeMonthView: UIView = {
        let view = UIView()
        return view
    }()
    private let selectedMonthLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyB1
        label.textColor = .gray6
        return label
    }()
    private let wholeMonthImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "NextMonth")
        return view
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
        view.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
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
        view.register(CalendarPlaceCollectionViewCell.self, forCellWithReuseIdentifier: CalendarPlaceCollectionViewCell.identifier)
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
        view.register(CalendarPlantCollectionViewCell.self, forCellWithReuseIdentifier: CalendarPlantCollectionViewCell.identifier)
        view.isScrollEnabled = true
        
        return view
    }()
    private let messageView: UIView = {
        let view = UIView()
        view.isHidden = true
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
        view.register(CalendarMemoCollectionViewCell.self, forCellWithReuseIdentifier: CalendarMemoCollectionViewCell.identifier)
        view.isScrollEnabled = false
        
        return view
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setConstraints()
    }
    
    func setConstraints() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [calendarView, placeCollectionView, plantCollectionView, messageView, divisionView, memoCollectionView].forEach {
            contentView.addSubview($0)
        }
        
        [wholeMonthView, previousButton, nextButton, weekStackView, calendarCollectionView].forEach {
            calendarView.addSubview($0)
        }
        
        [selectedMonthLabel, wholeMonthImageView].forEach {
            wholeMonthView.addSubview($0)
        }
        
        [firstMetView, firstMetLabel, waterView, waterLabel].forEach {
            messageView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.height.greaterThanOrEqualToSuperview().priority(.low)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        wholeMonthView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(11)
            make.height.equalTo(44)
        }
        
        selectedMonthLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(5)
        }
        
        wholeMonthImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(selectedMonthLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(5)
            make.width.equalTo(6.98)
            make.height.equalTo(11.68)
        }
        
        previousButton.snp.makeConstraints { make in
            make.centerY.equalTo(selectedMonthLabel.snp.centerY)
            make.trailing.equalTo(nextButton.snp.leading).offset(-6)
            make.width.height.equalTo(36)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(selectedMonthLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(7.5)
            make.width.height.equalTo(36)
        }
        
        weekStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(wholeMonthView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(7.5)
            make.height.equalTo(40)
        }
        
        calendarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(weekStackView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(7.5)
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(200)
        }
        
        placeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(40)
        }
        
        plantCollectionView.snp.makeConstraints { make in
            make.top.equalTo(placeCollectionView.snp.bottom).offset(21)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(124)
        }
        
        messageView.snp.makeConstraints { make in
            make.top.equalTo(plantCollectionView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(26)
            make.height.equalTo(44)
        }
        
        firstMetView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(7)
            make.leading.equalToSuperview()
        }
        
        firstMetLabel.snp.makeConstraints { make in
            make.centerY.equalTo(firstMetView.snp.centerY)
            make.leading.equalTo(firstMetView.snp.trailing).offset(19)
        }
        
        waterView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(7)
            make.leading.equalToSuperview()
        }
        
        waterLabel.snp.makeConstraints { make in
            make.centerY.equalTo(waterView.snp.centerY)
            make.leading.equalTo(waterView.snp.trailing).offset(19)
        }
        
        divisionView.snp.makeConstraints { make in
            make.top.equalTo(messageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(2)
        }
        
        memoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(divisionView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}
