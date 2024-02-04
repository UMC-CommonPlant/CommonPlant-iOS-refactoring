//
//  AddPlantSecondViewController.swift
//  CommonPlant
//
//  Created by 아라 on 1/25/24.
//

import UIKit
import SnapKit

class AddPlantSecondViewController: UIViewController {
    private let scrollView: UIView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    private let contentView = UIView()
    private let plantView: UIView = {
        let view = UIView()
        return view
    }()
    private let plantImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "AddPlant")
        return view
    }()
    private let cameraImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "CameraMark")
        return view
    }()
    private let nameBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .seaGreen
        return view
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyM1
        label.textColor = .gray4
        return label
    }()
    private let nameUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    private let nicknameView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let nicknameTextField: UITextField = {
        let tf = UITextField()
        tf.font = .bodyM1
        tf.textColor = .black
        tf.placeholder = "식물 애칭을 입력해주세요"
        tf.clearButtonMode = .whileEditing
        tf.returnKeyType = .done
        return tf
    }()
    private let nicknameUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    private let nicknameCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/10"
        label.font = .captionB1
        label.textColor = .gray5
        label.partiallyChanged(targetString: "/10", font: .captionM1, color: .gray5)
        return label
    }()
    private let placeBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray1
        return view
    }()
    private let placeChoiceLabel: UILabel = {
        let label = UILabel()
        label.text = "장소 선택"
        label.font = .bodyM1
        label.textColor = .gray6
        return label
    }()
    private let selectedPlaceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyM1
        label.textColor = .gray6
        return label
    }()
    private let deleteButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Delete")?.withTintColor(.gray3!)
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        button.configuration = config
        button.isHidden = true
        return button
    }()
    private let nextImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Next")
        return view
    }()
    private let placeUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    private let placeCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: 250, height: 156)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.isHidden = true
        return view
    }()
    private let dateView: UIView = {
        let view = UIView()
        return view
    }()
    private let lastWateredDayLabel: UILabel = {
        let label = UILabel()
        label.text = "마지막으로 물 준 날짜"
        label.font = .bodyM1
        label.textColor = .gray6
        return label
    }()
    private let selectedDateLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.font = .bodyM1
        label.textColor = .gray6
        label.padding = UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6)
        label.backgroundColor = .gray1
        label.makeRound(radius: 6)
        return label
    }()
    private let dateUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
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
    private let previousButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Previous")
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        button.configuration = config
        return button
    }()
    private let nextButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Previous")
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        button.configuration = config
        return button
    }()
    private let weekStackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.spacing = 4
        
        ["일", "월", "화", "수", "목", "금", "토"].forEach {
            let label = UILabel()
            label.text = $0
            label.font = .bodyM3
            label.textColor = .gray5
            
            view.addArrangedSubview(label)
        }
        return view
    }()
    private let datePickerCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 4
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: 40, height: 40)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return view
    }()
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "선택하지 않을 시, 등록일을 기준으로 설정합니다"
        label.font = .captionM2
        label.textColor = .seaGreenDark3
        return label
    }()
    private let cancleButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attribute = AttributedString.init("취소")
        attribute.font = .bodyM3
        config.attributedTitle = attribute
        config.baseForegroundColor = .white
        button.configuration = config
        button.backgroundColor = .gray5
        button.makeRound(radius: 4)
        return button
    }()
    private let submitButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attribute = AttributedString.init("등록")
        attribute.font = .bodyM3
        config.attributedTitle = attribute
        config.baseForegroundColor = .white
        button.configuration = config
        button.backgroundColor = .seaGreenDark1
        button.makeRound(radius: 4)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [plantView, nameBackgroundView, nicknameView, placeBackgroundView, placeCollectionView, dateView, calendarView, messageLabel, cancleButton, submitButton].forEach {
            contentView.addSubview($0)
        }
        
        [plantImageView, cameraImageView].forEach{ plantView.addSubview($0)}
        
        [nameLabel, nameUnderlineView].forEach { nameBackgroundView.addSubview($0)}
        
        [nicknameTextField, nicknameCountLabel, nicknameUnderlineView].forEach {
            nicknameView.addSubview($0)
        }
        
        [placeChoiceLabel, selectedPlaceLabel, nextImageView, deleteButton, placeUnderlineView].forEach {
            placeBackgroundView.addSubview($0)
        }
        
        [lastWateredDayLabel, selectedDateLabel, dateUnderlineView].forEach {
            dateView.addSubview($0)
        }
        
        [selectedMonthLabel, previousButton, nextButton, weekStackView, datePickerCollectionView].forEach {
            calendarView.addSubview($0)
        }
    }
    
    func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.height.greaterThanOrEqualToSuperview().priority(.low)
        }
        
        plantView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        plantImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        nameBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(plantView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        nameUnderlineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        nicknameView.snp.makeConstraints { make in
            make.top.equalTo(nameBackgroundView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        nicknameCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        nicknameUnderlineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        placeBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(nicknameView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        
        placeChoiceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(12)
            make.width.height.equalTo(40)
        }
        
        selectedPlaceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(deleteButton.snp.leading)
        }
        
        placeUnderlineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        placeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(placeBackgroundView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
        
        dateView.snp.makeConstraints { make in
            make.top.equalTo(placeCollectionView.isHidden ? placeBackgroundView.snp.bottom : placeCollectionView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview() // TODO: safeArea에 맞춘거랑 비교해보기
            make.height.equalTo(56)
        }
        
        lastWateredDayLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        selectedDateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        dateUnderlineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(dateView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        selectedMonthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(12)
            make.height.equalTo(24)
        }
        
        previousButton.snp.makeConstraints { make in
            make.centerY.equalTo(selectedMonthLabel.snp.centerY)
            make.trailing.equalTo(nextButton.snp.leading).offset(-6)
            make.width.height.equalTo(36)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(selectedMonthLabel.snp.centerY)
            make.trailing.equalToSuperview()
            make.width.height.equalTo(36)
        }
        
        weekStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(selectedMonthLabel.snp.bottom).offset(4)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        
        datePickerCollectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(weekStackView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarView.isHidden ? dateView.snp.bottom : calendarView.snp.bottom).offset(1)
            make.leading.equalToSuperview()
        }
        
        cancleButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(90)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(90)
            make.leading.equalTo(cancleButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.width.equalTo(cancleButton.snp.width)
            make.height.equalTo(40)
        }
    }
}
