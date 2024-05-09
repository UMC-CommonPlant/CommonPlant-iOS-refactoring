//
//  CalendarViewController.swift
//  CommonPlant
//
//  Created by 아라 on 3/6/24.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

#Preview {
    UINavigationController(rootViewController: CalendarViewController())
}

class CalendarViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = CalendarViewModel()
    private lazy var input = CalendarViewModel.Input(wholeMonthBtnDidTap: wholeMonthView.rx.tapGesture().map { _ in }.asObservable(), selectedMonth: selectedMonth.asObservable(), previousMonthBtnDidTap: previousButton.rx.tap.asObservable(), nextMonthBtnDidTap: nextButton.rx.tap.asObservable(), selectedDate: calendarCollectionView.rx.itemSelected.asObservable(), selectedPlace: placeCollectionView.rx.itemSelected.asObservable(), selectedPlant: plantCollectionView.rx.itemSelected.asObservable())
    private lazy var output = viewModel.transform(input: input)
    private lazy var selectedMonth = BehaviorRelay<Date>(value: Date())
    
    private lazy var cellWidth = (self.view.frame.width - 89) / 7
    
    // MARK: - UI Components
    private let scrollView: UIView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
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
            label.font = .bodyM1
            label.textColor = .gray5
            label.textAlignment = .center
            
            view.addArrangedSubview(label)
            
            label.snp.makeConstraints { make in
                make.width.height.equalTo(44)
            }
        }
        return view
    }()
    private lazy var calendarCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cellHeight = cellWidth
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 6
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.isScrollEnabled = false
        view.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        return view
    }()
    private let datePickerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.makeRound(radius: 12)
        view.layer.borderColor = UIColor.seaGreen?.cgColor
        view.layer.borderWidth = 2
        view.isHidden = true
        return view
    }()
    private let cancleButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attribute = AttributedString.init("취소")
        attribute.font = .bodyB2
        config.attributedTitle = attribute
        config.baseForegroundColor = .gray5
        button.configuration = config
        return button
    }()
    private let okButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attribute = AttributedString.init("확인")
        attribute.font = .bodyB2
        config.attributedTitle = attribute
        config.baseForegroundColor = .seaGreenDark3
        button.configuration = config
        return button
    }()
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        return picker
    }()
    private let placeCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.estimatedItemSize = CGSize(width: 40, height: 40)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        flowLayout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.register(CalendarPlaceCollectionViewCell.self, forCellWithReuseIdentifier: CalendarPlaceCollectionViewCell.identifier)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    private let plantCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: 106, height: 124)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 21, left: 16, bottom: 24, right: 16)
        flowLayout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.register(CalendarPlantCollectionViewCell.self, forCellWithReuseIdentifier: CalendarPlantCollectionViewCell.identifier)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    private let messageView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        return view
    }()
    private let firstMetView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    private let firstMetCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .sunflowerYellow
        view.makeRound(radius: 3)
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
        view.isHidden = true
        return view
    }()
    private let waterCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .aquaBlue
        view.makeRound(radius: 3)
        return view
    }()
    private let waterLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyB3
        label.textColor = .activeBlue
        return label
    }()
    private let memoView = UIView()
    private let memoCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .mauvePurple
        view.makeRound(radius: 3)
        return view
    }()
    private let memoLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyB3
        label.textColor = .activePurple
        return label
    }()
    private let divisionView: UIView = {
        let view = UIView()
        view.backgroundColor = .seaGreen
        return view
    }()
    private lazy var memoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets.init(top: 24, left: 20, bottom: 16, right: 20)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.register(CalendarMemoCollectionViewCell.self, forCellWithReuseIdentifier: CalendarMemoCollectionViewCell.identifier)
        view.isScrollEnabled = false
        
        view.rx.setDelegate(self).disposed(by: viewModel.disposeBag)
        return view
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
        bind()
        setConstraints()
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .gray6
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func bind() {
        view.rx
            .tapGesture(configuration: { gestureRecognizer, _ in
                gestureRecognizer.cancelsTouchesInView = false
            })
            .when(.recognized)
            .subscribe { [weak self] gesture in
                self?.handleTap(gesture)
                
            }.disposed(by: viewModel.disposeBag)
        
        cancleButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }
            
            datePickerView.isHidden = true
        }.disposed(by: viewModel.disposeBag)
                                    
        okButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }
            
            selectedMonth.accept(datePicker.date)
            datePickerView.isHidden = true
        }.disposed(by: viewModel.disposeBag)
        
        placeCollectionView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self else { return }
            guard let selectedCell = placeCollectionView.cellForItem(at: indexPath) as? CalendarPlaceCollectionViewCell else { return }
            guard let deselectedCell = placeCollectionView.cellForItem(at: viewModel.selectedPlace) as? CalendarPlaceCollectionViewCell else { return }
            
            selectedCell.setSelectedCell()
            if selectedCell != deselectedCell {
                deselectedCell.setDeselectedCell()
            }
        }.disposed(by: viewModel.disposeBag)
        
        plantCollectionView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self else { return }
            guard let selectedCell = plantCollectionView.cellForItem(at: indexPath) as? CalendarPlantCollectionViewCell else { return }
            guard let deselectedCell = plantCollectionView.cellForItem(at: viewModel.selectedPlant) as? CalendarPlantCollectionViewCell else { return }
            
            selectedCell.setSelectedCell()
            if selectedCell != deselectedCell {
                deselectedCell.setDeselectedCell()
            }
        }.disposed(by: viewModel.disposeBag)
        
        memoCollectionView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self else { return }
            
            let nextVC = MemoListViewController(focus: indexPath)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.currentMonth.subscribe { [weak self] month in
            guard let self = self else { return }
            
            selectedMonthLabel.text = month
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.days
            .do(onNext: { [weak self] days in
                guard let self = self else { return }
                let numberOfRow = days.count / 7
                let newHeight = cellWidth * CGFloat(numberOfRow + (days.count % 7 > 0 ? 1 : 0))
                calendarCollectionView.snp.updateConstraints { make in
                    make.height.equalTo(newHeight)
                }
            })
            .bind(to: calendarCollectionView.rx.items(cellIdentifier: CalendarCollectionViewCell.identifier, cellType: CalendarCollectionViewCell.self)) { [weak self] (_, result, cell) in
            guard let self = self else { return }
            
            cell.setConfigure(with: result, isSelected: viewModel.checkSelectedDay(day: result), isToday: viewModel.checkToday(day: result))
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.placeList.bind(to: placeCollectionView.rx.items(cellIdentifier: CalendarPlaceCollectionViewCell.identifier, cellType: CalendarPlaceCollectionViewCell.self)) { [weak self] (row, result, cell) in
            guard let self = self else { return }
            
            cell.setConfigure(whit: result)
            if row == 0 {
                cell.setSelectedCell()
            }
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.plantList.bind(to: plantCollectionView.rx.items(cellIdentifier: CalendarPlantCollectionViewCell.identifier, cellType: CalendarPlantCollectionViewCell.self)) { [weak self] (row, result, cell) in
            guard let self = self else { return }
            
            cell.setConfigure(whit: result, index: row)
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.messageList.subscribe { [weak self] messages in
            guard let self = self else { return }
            guard let messages = messages.element else { return }
            
            checkMessage(messages)
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.memoList
            .do(onNext: { [weak self] memos in
                guard let self = self else { return }
                
                let topInset: CGFloat = 24
                let bottomInset: CGFloat = 16
                
                var totalHeight: CGFloat = 0.0
                let contentLabelTop: CGFloat = 52
                let verticalInset: CGFloat = 20
                let spacing: CGFloat = 16
                
                for memo in memos {
                    let cellWidth = self.memoCollectionView.frame.width - 38
                    let cellHeight = self.calculateHeightForText(memo.content, width: cellWidth) + contentLabelTop + verticalInset + spacing
                    totalHeight += cellHeight
                }
                
                self.memoCollectionView.snp.updateConstraints { make in
                    make.height.equalTo(totalHeight + topInset + bottomInset)
                }
                
                memoLabel.text = "메모가 \(memos.count)개 있어요"
            })
            .bind(to: memoCollectionView.rx.items(cellIdentifier: CalendarMemoCollectionViewCell.identifier, cellType: CalendarMemoCollectionViewCell.self)) { [weak self] (_, result, cell) in
                guard let self = self else { return }
                
                cell.setConfigure(with: result)
            }.disposed(by: viewModel.disposeBag)
        
        output.showWholeMonth.drive { [weak self] _ in
            guard let self = self else { return }
            
            datePickerView.isHidden = false
        }.disposed(by: viewModel.disposeBag)
        
        output.selectedDate.subscribe(onNext: { [weak self] date in
            guard let self = self else { return }
            calendarCollectionView.reloadData()
            datePicker.date = date
        }).disposed(by: viewModel.disposeBag)
    }
    
    func setConstraints() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [calendarView, placeCollectionView, plantCollectionView, messageView, divisionView, memoCollectionView].forEach {
            contentView.addSubview($0)
        }
        
        [wholeMonthView, previousButton, nextButton, weekStackView, calendarCollectionView, datePickerView].forEach {
            calendarView.addSubview($0)
        }
        
        [selectedMonthLabel, wholeMonthImageView].forEach {
            wholeMonthView.addSubview($0)
        }
        
        [datePicker, cancleButton, okButton].forEach {
            datePickerView.addSubview($0)
        }
        
        [firstMetView, waterView, memoView].forEach {
            messageView.addArrangedSubview($0)
        }
        
        [firstMetCircleView, firstMetLabel].forEach { firstMetView.addSubview($0) }
        
        [waterCircleView, waterLabel].forEach { waterView.addSubview($0) }
        
        [memoCircleView, memoLabel].forEach { memoView.addSubview($0) }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
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
        
        datePickerView.snp.makeConstraints { make in
            make.top.equalTo(wholeMonthView.snp.bottom)
            make.leading.equalToSuperview().offset(14)
            make.height.equalTo(160)
            make.width.equalTo(260)
        }
        
        cancleButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
        }
        
        okButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
        }
        
        datePicker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(116)
            make.width.equalTo(240)
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
            make.top.equalTo(wholeMonthView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(7.5)
            make.height.equalTo(40)
        }
        
        calendarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(weekStackView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(7.5)
            make.bottom.equalToSuperview()
            make.height.lessThanOrEqualTo(264).priority(.low)
        }
        
        placeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        plantCollectionView.snp.makeConstraints { make in
            make.top.equalTo(placeCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(169)
        }
        
        messageView.snp.makeConstraints { make in
            make.top.equalTo(plantCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(26)
        }
        
        firstMetView.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        firstMetCircleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.height.equalTo(6)
        }
        
        firstMetLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(firstMetCircleView.snp.trailing).offset(19)
        }
        
        waterView.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        waterCircleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.height.equalTo(6)
        }
        
        waterLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(waterCircleView.snp.trailing).offset(19)
        }
        
        memoView.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        memoCircleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.height.equalTo(6)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(memoCircleView.snp.trailing).offset(19)
        }
        
        divisionView.snp.makeConstraints { make in
            make.top.equalTo(messageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(2)
        }
        
        memoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(divisionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func handleTap(_ gesture: UITapGestureRecognizer) {
        if datePickerView.isHidden { return }
        
        let location = gesture.location(in: datePickerView)
        if !datePickerView.frame.contains(location) {
            datePickerView.isHidden = true
        }
    }
    
    func checkMessage(_ messages : [String]) {
        firstMetView.isHidden = true
        waterView.isHidden = true
        
        // TODO: 네트워크 후 수정하기
        for msg in messages {
            switch msg {
            case "처음 데려온 날이에요" :
                firstMetView.isHidden = false
            case "물 주는 날이에요" :
                waterLabel.text = "물 주는 날이에요"
                waterView.isHidden = false
            case "물을 줬어요!" :
                waterLabel.text = "물을 줬어요!"
                waterView.isHidden = false
            default : return
            }
        }
    }
}

extension CalendarViewController: UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 38
        let text = viewModel.memoList.value[indexPath.row].content
        
        let contentLabelTop: CGFloat = 52
        let verticalInset: CGFloat = 20
        
        let cellHeight = calculateHeightForText(text, width: cellWidth) + contentLabelTop + verticalInset
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func calculateHeightForText(_ text: String, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 3
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
}
