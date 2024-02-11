//
//  AddPlantSecondViewController.swift
//  CommonPlant
//
//  Created by 아라 on 1/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

class AddPlantSecondViewController: UIViewController {
    private let viewModel = AddPlantSecondViewModel()
    private lazy var input = AddPlantSecondViewModel
        .Input(imageDidTap: plantImageView.rx.tapGesture().map { _ in }.asObservable(),
               selectedNewImage: selectNewImage.asObservable(),
               selectedDefaultImage: changeToDefaultImage.asObservable(),
               selectedCancle: cancelImageSetting.asObservable(),
               editingNickname: nicknameTextField.rx.text.orEmpty.asObservable(),
               placeDidTap: placeBackgroundView.rx.tapGesture().map { _ in }.asObservable(),
               selectedPlace: placeCollectionView.rx.itemSelected.asObservable(),
               deletePlaceBtnDidTap: deleteButton.rx.tap.asObservable(),
               dateDidTap: selectedDateLabel.rx.tapGesture().map { _ in }.asObservable(),
               previousMonthBtnDidTap: previousButton.rx.tap.asObservable(),
               nextMonthBtnDidTap: nextButton.rx.tap.asObservable(),
               selectedDate: datePickerCollectionView.rx.itemSelected.asObservable(),
               cancleBtnDidTap: cancleButton.rx.tap.asObservable(),
               submitBtnDidTap: submitButton.rx.tap.asObservable())
    private lazy var output = viewModel.transform(input: input)
    private let selectNewImage = PublishRelay<Void>()
    private let changeToDefaultImage = PublishRelay<Void>()
    private let cancelImageSetting = PublishRelay<Void>()
    
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
        tf.tintColor = .black
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
        label.textAlignment = .right
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
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.register(PlaceCollectionViewCell.self, forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
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
        label.padding = UIEdgeInsets(top: 10, left: 6, bottom: 8, right: 6)
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
    private let datePickerCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 4
        flowLayout.itemSize = CGSize(width: 40, height: 40)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.isScrollEnabled = false
        view.register(DatePickerCollectionViewCell.self, forCellWithReuseIdentifier: DatePickerCollectionViewCell.identifier)
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
        config.baseForegroundColor = .gray3
        button.configuration = config
        button.backgroundColor = .gray1
        button.makeRound(radius: 4)
        button.isEnabled = true
        return button
    }()
    
    init(name: String) {
        nameLabel.text = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
        setHierarchy()
        setConstraints()
    }
    
    func bind() {
        viewModel.currentMonth.bind { [weak self] month in
            guard let self = self else { return }
            
            selectedMonthLabel.text = month
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.selectedDate.bind { [weak self] date in
            guard let self = self else { return }
            
            selectedDateLabel.text = date
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.placeList.bind(to: placeCollectionView.rx.items(cellIdentifier: PlaceCollectionViewCell.identifier, cellType: PlaceCollectionViewCell.self)) { (_, result, cell) in
            
            cell.setConfigure(with: result)
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.days.bind(to: datePickerCollectionView.rx.items(cellIdentifier: DatePickerCollectionViewCell.identifier, cellType: DatePickerCollectionViewCell.self)) { [weak self] (_, result, cell) in
            guard let self = self else { return }
            
            let isSelectedDay = viewModel.checkSelectedDay(day: result)
            let isToday = viewModel.checkToday(day: result)
            
            cell.setConfigure(with: result, isSelected: isSelectedDay, isToday: isToday)
        }.disposed(by: viewModel.disposeBag)
        
        output.showImgSettingAlert.drive { [weak self] _ in
            guard let self = self else { return }
            
            self.showImageSettingAlert { state in
                switch state {
                case .newImage:
                    self.selectNewImage.accept(())
                case .defaultImage:
                    self.changeToDefaultImage.accept(())
                case .cancle:
                    self.cancelImageSetting.accept(())
                }
            }
        }.disposed(by: viewModel.disposeBag)
        
        output.showImagePicker.drive { [weak self] _ in
            guard let self = self else { return }
            
        }.disposed(by: viewModel.disposeBag)
        
        output.changeDefaultImage.drive { [weak self] _ in
            guard let self = self else { return }
            
            plantImageView.image = UIImage(named: "AddPlant")
        }.disposed(by: viewModel.disposeBag)
        
        output.cancleSelectImage.drive { [weak self] _ in
            guard let self = self else { return }
            
        }.disposed(by: viewModel.disposeBag)
        
        output.nicknameState.drive { [weak self] nickname in
            guard let self = self else { return }
            
            nicknameTextField.text = nickname
            nicknameCountLabel.text = "\(nickname.count)/10"
            nicknameCountLabel.textColor = nickname.count > 0 ? .black : .gray5
            nicknameCountLabel.partiallyChanged(targetString: "/10", font: .captionM1, color: .gray5)
        }.disposed(by: viewModel.disposeBag)
        
        output.showPlaceList.drive { [weak self] _ in
            guard let self = self else { return }
            
            placeCollectionView.isHidden = false
            
            dateView.snp.remakeConstraints { make in
                make.top.equalTo(self.placeCollectionView.snp.bottom).offset(32)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(56)
            }
        }.disposed(by: viewModel.disposeBag)
        
        output.selectPlace.drive { [weak self] place in
            guard let self = self else { return }
            
            placeChoiceLabel.text = "장소"
            selectedPlaceLabel.text = place.placeName
            deleteButton.isHidden = false
            nextImageView.isHidden = true
            placeCollectionView.isHidden = true
            dateView.snp.remakeConstraints { make in
                make.top.equalTo(self.placeBackgroundView.snp.bottom).offset(32)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(56)
            }
        }.disposed(by: viewModel.disposeBag)
        
        output.resetPlace.drive { [weak self] _ in
            guard let self = self else { return }
            
            placeChoiceLabel.text = "장소 선택"
            selectedPlaceLabel.text = ""
            deleteButton.isHidden = true
            nextImageView.isHidden = false
        }.disposed(by: viewModel.disposeBag)
        
        output.showDatePicker.drive { [weak self] _ in
            guard let self = self else { return }
            
            calendarView.isHidden = false
            
            messageLabel.snp.remakeConstraints { make in
                make.top.equalTo(self.calendarView.snp.bottom).offset(4)
                make.leading.equalToSuperview()
            }
        }.disposed(by: viewModel.disposeBag)
        
        output.selectDate.drive { [weak self] indexPath in
            guard let self = self else { return }
            
            setCalendar(indexPath)
        }.disposed(by: viewModel.disposeBag)
        
        output.cancleAddPlant.drive { [weak self] _ in
            guard let self = self else { return }
            // TODO: navigation pop
        }.disposed(by: viewModel.disposeBag)
        
        output.submitPlant.drive { [weak self] _ in
            guard let self = self else { return }
            // TODO: navigation pop
        }.disposed(by: viewModel.disposeBag)
        
        output.submitBtnState.drive { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .enable:
                submitButton.isEnabled = true
                submitButton.backgroundColor = .seaGreenDark1
                submitButton.configuration?.baseForegroundColor = .white
            case .disable:
                submitButton.isEnabled = true
                submitButton.backgroundColor = .gray1
                submitButton.configuration?.baseForegroundColor = .gray3
            case .onClick:
                submitButton.backgroundColor = .seaGreenDark3
                submitButton.configuration?.baseForegroundColor = .white
            }
        }.disposed(by: viewModel.disposeBag)
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
            make.leading.equalToSuperview()
            make.trailing.equalTo(nicknameCountLabel.snp.leading).offset(-5)
        }
        
        nicknameCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(nicknameTextField.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
            make.width.equalTo(35)
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
        
        nextImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(-12)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(0)
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
            make.height.equalTo(156)
        }
        
        dateView.snp.makeConstraints { make in
            make.top.equalTo(placeBackgroundView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
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
            make.leading.trailing.equalToSuperview().inset(7.5)
            make.height.equalTo(40)
        }
        
        datePickerCollectionView.snp.makeConstraints { make in
            make.top.equalTo(weekStackView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(7.5)
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(200)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(dateView.snp.bottom).offset(1)
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
    
    func setCalendar(_ indexPath: IndexPath) {
        for cell in datePickerCollectionView.visibleCells {
            guard let cell = cell as? DatePickerCollectionViewCell else { return }
            guard let day = cell.dayLabel.text else { return }
            cell.circleView.isHidden = true
            cell.dayLabel.textColor = viewModel.checkToday(day: day) ? .seaGreenDark2 : .black
        }
        
        guard let selectDay = datePickerCollectionView.cellForItem(at: indexPath) as? DatePickerCollectionViewCell else { return }
        selectDay.circleView.isHidden = false
        selectDay.dayLabel.textColor = .gray2
    }
}
