//
//  MyPlantViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/25.
//

import UIKit
import RxSwift
import RxRelay
import SnapKit
import Kingfisher
import Then

class MyPlantViewController: UIViewController {
    // MARK: Properties
    let viewModel: MyPlantViewModel
    private lazy var input = MyPlantViewModel
        .Input(enterMyPlant: viewAppearSubject.asObserver(),
               menuBtnDidTap: menuButton.rx.tap.asObservable(),
               editBtnDidTap: menuView.editView.rx.tapGesture().map { _ in }.asObservable().skip(1),
               deleteBtnDidTap: menuView.deleteView.rx.tapGesture().map { _ in }.asObservable().skip(1),
               alertDeleteBtnDidTap: alertView.actionButton.rx.tap.asObservable(),
               alertCancelBtnDidTap: alertView.cancleButton.rx.tap.asObservable(),
               backgroundViewDidTap: backgroundView.rx.tapGesture().map { _ in }.asObservable(),
               writeBtnDidTap: addMemoButton.rx.tap.asObservable(),
               memoListDidTap: nextButton.rx.tap.asObservable())
    private lazy var output = viewModel.transform(input: input)
    private let viewAppearSubject = PublishSubject<Void>()
    let plantIdx: Int
    
    // MARK: UIComponents
    private let scrollView = UIScrollView()
    private let stackView = UIStackView().then {
        $0.backgroundColor = .gray1
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }
    private let plantProfileView = UIView().then {
        $0.backgroundColor = .white
    }
    private let menuButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Menu")
        $0.configuration = config
    }
    private let backgroundView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.opacity = 0.4
        $0.isHidden = true
    }
    private let menuView = CommonMenuView().then {
        $0.isHidden = true
    }
    private let alertView = CommonAlertView().then {
        $0.isHidden = true
        $0.setTitle("식물 삭제")
        $0.setMessage("해당 식물을 삭제하시겠습니까?")
        $0.setActionButton(title: "삭제")
    }
    private let plantImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.makeRound(radius: 16)
    }
    private let placeView = UIView().then {
        $0.backgroundColor = .seaGreenDark3
        $0.makeRound(radius: 8)
    }
    private let placeImageView = UIImageView().then {
        $0.image = UIImage(named: "Place")
    }
    private let placeNameLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .bodyB3
    }
    private let nickNameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .head5
        $0.textAlignment = .center
    }
    private let scientificNameLabel = UILabel().then {
        $0.textColor = .gray6
        $0.font = .bodyM2
        $0.textAlignment = .center
    }
    private let dateInfoView = UIView().then {
        $0.backgroundColor = .white
    }
    private let countingMessageLabel = UILabel().then {
        $0.textColor = .gray5
        $0.font = .bodyM2
        $0.textAlignment = .center
    }
    private let wateringView = UIView()
    private let wateringImageView = UIImageView().then {
        $0.image = UIImage(named: "WateringCan")
    }
    private let waterDayLabel = UILabel().then {
        $0.textColor = .gray6
        $0.font = .head4
        $0.textAlignment = .center
    }
    private let infoView = UIView()
    private let messageView = UIView()
    private let dateView = UIView()
    private let metMessageLabel = UILabel().then {
        $0.text = "처음 함께한 날"
        $0.textColor = .gray4
        $0.font = .captionM1
        $0.textAlignment = .center
    }
    private let metDateLabel = UILabel().then {
        $0.textColor = .gray4
        $0.font = .captionM1
        $0.textAlignment = .center
    }
    private let lastWateringMessageLabel = UILabel().then {
        $0.text = "마지막으로 물 준 날짜"
        $0.textColor = .gray4
        $0.font = .captionM1
        $0.textAlignment = .center
    }
    private let lastWateringDateLabel = UILabel().then {
        $0.textColor = .gray4
        $0.font = .captionM1
        $0.textAlignment = .center
    }
    private let memoView = UIView().then {
        $0.backgroundColor = .white
    }
    private let memoTitleLabel = PaddingLabel().then {
        $0.text = "Memo"
        $0.textColor = .gray4
        $0.font = .bodyB1
        $0.padding = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 0)
    }
    private let nextButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Next")
        $0.configuration = config
    }
    private lazy var memoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.backgroundColor = .clear
        $0.register(MemoCardCollectionViewCell.self, forCellWithReuseIdentifier: MemoCardCollectionViewCell.identifier)
    }
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 8
        $0.itemSize = CGSize(width: 250, height: 174)
        $0.sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
    }
    private let addMemoButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        var attr = AttributedString.init("작성하기")
        attr.font = .bodyB3
        config.attributedTitle = attr
        config.baseForegroundColor = .white
        
        $0.configuration = config
        $0.contentHorizontalAlignment = .center
        $0.backgroundColor = .seaGreenDark1
        $0.makeRound(radius: 8)
    }
    private let plantInfoView = UIView().then {
        $0.backgroundColor = .white
    }
    private let infoTitleLabel = PaddingLabel().then {
        $0.text = "식물정보"
        $0.textColor = .gray4
        $0.font = .bodyB1
        $0.padding = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 0)
    }
    private let infoBackgroundView = UIView().then {
        $0.backgroundColor = .seaGreen
        $0.makeRound(radius: 16)
    }
    private let wateringCycleImage = UIImageView().then {
        $0.image = UIImage(named: "WateringPot")
    }
    private let wateringCycleLabel = UILabel().then {
        $0.textColor = .gray6
        $0.font = .captionM1
        $0.textAlignment = .left
    }
    private let cautionLabel = UILabel().then {
        $0.text = "물을 좋아하나 과습에 주의하세요!"
        $0.textColor = .gray5
        $0.font = .captionM2
        $0.textAlignment = .center
    }
    private let sunlightImageView = UIImageView().then {
        $0.image = UIImage(named: "Sunlight")
    }
    private let sunlightInfoLabel = UILabel().then {
        $0.textColor = .gray6
        $0.font = .captionM1
        $0.textAlignment = .left
    }
    private let temperatureImageView = UIImageView().then {
        $0.image = UIImage(named: "Temperature")
    }
    private let temperatureLabel = UILabel().then {
        $0.textColor = .gray6
        $0.font = .captionM1
        $0.textAlignment = .left
    }
    private let humidityInfoImageView = UIImageView().then {
        $0.image = UIImage(named: "Humidity")
    }
    private let humidityInfoLabel = UILabel().then {
        $0.textColor = .gray6
        $0.font = .captionM1
        $0.textAlignment = .left
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        bind()
        setNavigationBar()
        setHierarchy()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backgroundView.isHidden = true
        menuView.isHidden = true
        viewAppearSubject.onNext(())
    }
    
    init(plantIdx: Int) {
        self.plantIdx = plantIdx
        self.viewModel = MyPlantViewModel(plantIdx)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Custom Methods
    func setNavigationBar() {
        navigationItem.title = "My Plant"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bodyB1, .foregroundColor: UIColor.gray6 as Any]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    func bind() {
        viewModel.myPlant.bind { [weak self] plant in
            guard let self, let plant = plant else { return }
            
            if let imgURL = URL(string: plant.imgURL) {
                plantImageView.kf.setImage(with: imgURL)
            } else {
                plantImageView.image = UIImage(named: "MyPlant")
            }
            
            placeNameLabel.text = plant.place
            nickNameLabel.text = plant.nickname
            scientificNameLabel.text = plant.scientificName
            countingMessageLabel.text = "\(plant.nickname)와/과 함께한지 \(plant.countDate)일이 지났어요!"
            countingMessageLabel.partiallyChanged(targetString: "\(plant.countDate)일", font: .bodyB1, color: .gray6)
            waterDayLabel.text = "D\(plant.remainderDate)"
            metDateLabel.text = plant.createdAt
            lastWateringDateLabel.text = plant.wateredDate
            wateringCycleLabel.text = "\(plant.waterDay) Day"
            sunlightInfoLabel.text = "\(plant.sunlight)"
            temperatureLabel.text = "\(plant.tempMin)~\(plant.tempMax)℃"
            humidityInfoLabel.text = "\(plant.humidity)"
            
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.plantMemoList
            .do (onNext: { [weak self] memos in
                guard let self = self else { return }
                
                if memos.isEmpty {
                    memoCollectionView.snp.updateConstraints { make in
                        make.height.equalTo(0)
                    }
                } else {
                    memoCollectionView.snp.updateConstraints { make in
                        make.height.equalTo(174)
                    }
                }
            })
            .bind(to: memoCollectionView.rx.items(cellIdentifier: MemoCardCollectionViewCell.identifier, cellType: MemoCardCollectionViewCell.self)) { (_, result, cell) in
                
                cell.configureCell(result)
            }.disposed(by: viewModel.disposeBag)
        
        output.backgroundHidden.drive { [weak self] _ in
            guard let self else { return }
            backgroundView.isHidden = true
            alertView.isHidden = true
            menuView.isHidden = true
        }.disposed(by: viewModel.disposeBag)
        
        output.showMenu.drive { [weak self] _ in
            guard let self else { return }
            
            menuView.isHidden = false
            backgroundView.isHidden = false
        }.disposed(by: viewModel.disposeBag)
        
        output.showDeleteAlert.drive { [weak self] _ in
            guard let self else { return }
            
            menuView.isHidden = true
            alertView.isHidden = false
            backgroundView.isHidden = false
        }.disposed(by: viewModel.disposeBag)
        
        output.showEditView.drive { [weak self] (nickname, waterCycle, imagString) in
            guard let self else { return }
            let nextVC = EditPlantViewController(plantIdx, plantNickname: nickname, waterCycle: waterCycle, imgURL: imagString)
            
            navigationController?.pushViewController(nextVC, animated: true)
        }.disposed(by: viewModel.disposeBag)
        
        output.showAddMemoView.drive { [weak self] index in
            guard let self else { return }
            
            navigationController?.pushViewController(EditMemoViewController(), animated: true)
        }.disposed(by: viewModel.disposeBag)
        
        output.showMemoView.drive { [weak self] index in
            guard let self else { return }
            
            navigationController?.pushViewController(MemoListViewController(focus: IndexPath(item: 0, section: 0)), animated: true)
        }.disposed(by: viewModel.disposeBag)
        
        output.popToPreviousView.drive { [weak self] _ in
            guard let self else { return }
            
            navigationController?.popViewController(animated: true)
        }.disposed(by: viewModel.disposeBag)
    }
    
    func setHierarchy() {
        [scrollView, backgroundView, menuView, alertView].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(stackView)
        
        [plantProfileView, dateInfoView, memoView, plantInfoView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [menuButton, plantImageView, placeView, nickNameLabel, scientificNameLabel].forEach {
            plantProfileView.addSubview($0)
        }
        
        [placeImageView, placeNameLabel].forEach {
            placeView.addSubview($0)
        }
        
        [countingMessageLabel, wateringView, infoView].forEach {
            dateInfoView.addSubview($0)
        }
        
        [wateringImageView, waterDayLabel].forEach {
            wateringView.addSubview($0)
        }
        
        [messageView, dateView].forEach {
            infoView.addSubview($0)
        }
        
        [metMessageLabel, lastWateringMessageLabel].forEach {
            messageView.addSubview($0)
        }
        
        [metDateLabel, lastWateringDateLabel].forEach {
            dateView.addSubview($0)
        }
        
        [memoTitleLabel, nextButton, memoCollectionView, addMemoButton].forEach {
            memoView.addSubview($0)
        }
        
        [infoTitleLabel, infoBackgroundView].forEach {
            plantInfoView.addSubview($0)
        }
        
        [wateringCycleImage, wateringCycleLabel, cautionLabel, sunlightImageView, sunlightInfoLabel, temperatureImageView, temperatureLabel, humidityInfoImageView, humidityInfoLabel].forEach {
            infoBackgroundView.addSubview($0)
        }
    }
    
    func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(scrollView)
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview().priority(.low)
        }
        
        plantProfileView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(322)
        }
        
        menuButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.height.equalTo(32)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
        
        plantImageView.snp.makeConstraints { make in
            make.top.equalTo(menuButton.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(208)
        }
        
        menuView.snp.makeConstraints { make in
            make.top.equalTo(menuButton.snp.bottom).offset(4)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(228)
            make.height.equalTo(128)
        }
        
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalTo(148)
        }
        
        placeView.snp.makeConstraints { make in
            make.top.equalTo(plantImageView.snp.top).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
        
        placeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.leading.equalToSuperview().offset(10)
        }
        
        placeNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(placeImageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(plantImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
        
        scientificNameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.centerX.equalToSuperview()
        }
        
        dateInfoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(172)
        }
        
        countingMessageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        
        wateringView.snp.makeConstraints { make in
            make.top.equalTo(countingMessageLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(36)
        }
        
        wateringImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        waterDayLabel.snp.makeConstraints { make in
            make.leading.equalTo(wateringImageView.snp.trailing).offset(8)
            make.centerY.trailing.equalToSuperview()
        }
        
        infoView.snp.makeConstraints { make in
            make.top.equalTo(wateringView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        messageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        dateView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(messageView.snp.trailing).offset(34)
        }
        
        metMessageLabel.snp.makeConstraints { make in
            make.top.leading.centerX.equalToSuperview()
        }
        
        lastWateringMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(metMessageLabel.snp.bottom)
            make.leading.bottom.centerX.equalToSuperview()
        }
        
        metDateLabel.snp.makeConstraints { make in
            make.top.trailing.centerX.equalToSuperview()
        }
        
        lastWateringDateLabel.snp.makeConstraints { make in
            make.top.equalTo(metDateLabel.snp.bottom)
            make.trailing.bottom.centerX.equalToSuperview()
        }
        
        memoView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(48)
        }
        
        memoTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(nextButton.snp.leading)
        }
        
        memoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(memoTitleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(174)
        }
        
        addMemoButton.snp.makeConstraints { make in
            make.top.equalTo(memoCollectionView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(42)
            make.bottom.equalToSuperview().inset(24)
        }
        
        plantInfoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(274)
        }
        
        infoTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        infoBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(infoTitleLabel.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(188)
        }
        
        wateringCycleImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
        }
        
        wateringCycleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.leading.equalTo(wateringCycleImage.snp.trailing).offset(8)
        }
        
        cautionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(46)
            make.top.equalTo(wateringCycleLabel.snp.bottom).offset(6)
        }
        
        sunlightImageView.snp.makeConstraints { make in
            make.top.equalTo(cautionLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        sunlightInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(sunlightImageView.snp.top).offset(2)
            make.leading.equalTo(sunlightImageView.snp.trailing).offset(8)
        }
        
        temperatureImageView.snp.makeConstraints { make in
            make.top.equalTo(sunlightImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureImageView.snp.top).offset(2)
            make.leading.equalTo(temperatureImageView.snp.trailing).offset(8)
        }
        
        humidityInfoImageView.snp.makeConstraints { make in
            make.top.equalTo(temperatureImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
        }
        
        humidityInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(humidityInfoImageView.snp.top).offset(2)
            make.leading.equalTo(humidityInfoImageView.snp.trailing).offset(8)
        }
    }
}
