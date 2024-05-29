//
//  AddPlantSecondViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 1/23/24.
//

import Foundation
import RxSwift
import RxCocoa

class AddPlantSecondViewModel {
    let disposeBag = DisposeBag()
    let calendar = Calendar.current
    
    let placeList = BehaviorRelay<[PlaceListResult]>(value: [])
    let selectedDate = BehaviorRelay<String>(value: "")
    let currentMonth = BehaviorRelay<String>(value: "")
    let days = BehaviorRelay<[String]>(value: [])
    let todayDate = Date()
    var calendarDate = Date()
    var nicknameState: SubmitState = .disable
    var placeState: SubmitState = .disable
    
    init() {
        selectedDate.accept(dateToString(Date()))
        currentMonth.accept(dateToMonthString(Date()))
        updateDays()
        
        PlantAPI.shared.getPlaceListToAddPlant()
            .subscribe { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    placeList.accept(response.result)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }.disposed(by: self.disposeBag)
    }
    
    func stringToDate(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        
        return dateFormatter.date(from: string)
    }
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        
        return dateFormatter.string(from: date)
    }
    
    func dateToMonthString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        
        return dateFormatter.string(from: date)
    }
    
    func updateDays() {
        let dateComponents = calendar.dateComponents([.year, .month], from: calendarDate)
        guard let firstDayOfMonth = calendar.date(from: dateComponents) else { return }
        let weekdayOfFirstDay = calendar.component(.weekday, from: firstDayOfMonth)
        guard let numberOfDays = calendar.range(of: .day, in: .month, for: calendarDate)?.count else { return }
        let empty = Array(repeating: "", count: weekdayOfFirstDay - 1)
        let days = (1...numberOfDays).map { String($0) }
        
        self.days.accept(empty + days)
    }
    
    func checkToday(day: String) -> Bool {
        guard let day = Int(day) else { return false }
        guard let newDate = calendar.date(bySetting: .day, value: day, of: calendarDate) else { return false }
        
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: todayDate)
        let newDateComponents = calendar.dateComponents([.year, .month, .day], from: newDate)
        
        return todayComponents == newDateComponents
    }
    
    func isDateAfterToday(day: String) -> Bool {
        guard let day = Int(day) else { return false }
        
        var dateComponents = calendar.dateComponents([.year, .month], from: calendarDate)
        dateComponents.day = day
        
        guard let new = calendar.date(from: dateComponents) else { return false }
        
        return new > todayDate
    }

    func checkSelectedDay(day: String) -> Bool {
        guard let day = Int(day) else { return false }
        guard let newDate = calendar.date(bySetting: .day, value: day, of: calendarDate) else { return false }
        
        let target = dateToString(newDate)
        return selectedDate.value == target
    }
    
    func checkMonth() -> Bool {
        guard let selectedDate = stringToDate(selectedDate.value) else { return false }
        let selectYearAndMonth = calendar.dateComponents([.year, .month], from: selectedDate)
        let currentYearAndMonth = calendar.dateComponents([.year, .month], from: calendarDate)
        
        return selectYearAndMonth == currentYearAndMonth
    }
}

extension AddPlantSecondViewModel {
    enum SubmitState {
        case enable
        case disable
        case onClick
    }
}

extension AddPlantSecondViewModel {
    struct Input {
        let imageDidTap: Observable<Void>
        let selectedNewImage: Observable<Void>
        let selectedDefaultImage: Observable<Void>
        let editingNickname: Observable<String>
        let endEditingNickname: Observable<String?>
        let placeDidTap: Observable<Void>
        let selectedPlace: Observable<IndexPath>
        let deletePlaceBtnDidTap: Observable<Void>
        let dateDidTap: Observable<Void>
        let previousMonthBtnDidTap: Observable<Void>
        let nextMonthBtnDidTap: Observable<Void>
        let selectedDate: Observable<IndexPath>
        let cancleBtnDidTap: Observable<Void>
        let submitBtnDidTap: Observable<Void>
    }
    
    struct Output {
        let showImgSettingAlert: Driver<Void>
        let showImagePicker: Driver<Void>
        let changeDefaultImage: Driver<Void>
        let nicknameText: Driver<String>
        let showPlaceList: Driver<Void>
        let selectPlace: Driver<PlaceListResult>
        let resetPlace: Driver<Void>
        let showDatePicker: Driver<Void>
        let selectDate: Driver<IndexPath>
        let cancleAddPlant: Driver<Void>
        let submitPlant: Driver<Void>
        let submitBtnState: Driver<SubmitState>
    }
    
    func transform(input: Input) -> Output {
        let submitBtnState = BehaviorRelay(value: SubmitState.disable)
        
        let showImgSettingAlert = PublishRelay<Void>()
        input.imageDidTap.bind(to: showImgSettingAlert).disposed(by: disposeBag)
        let showImagePicker = PublishRelay<Void>()
        input.selectedNewImage.bind(to: showImagePicker).disposed(by: disposeBag)
        let changeDefaultImage = PublishRelay<Void>()
        input.selectedDefaultImage.bind(to: changeDefaultImage).disposed(by: disposeBag)
        let nicknameText = PublishRelay<String>()
        input.editingNickname.bind { [weak self] name in
            guard let self = self else { return }
            var name = name
            
            while name.contains("  ") {
                name = name.replacingOccurrences(of: "  ", with: " ")
            }
            
            if name.count > 10 {
                let index = name.index(name.startIndex, offsetBy: 10)
                name = String(name[..<index])
            }
            
            let pattern = "^[가-힣a-zA-Z0-9 !_.-^~]*$"
            
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                let range = NSRange(location: 0, length: name.utf16.count)
                
                if regex.firstMatch(in: name, options: [], range: range) == nil || name.count < 2 {
                    nicknameState = .disable
                    submitBtnState.accept(.disable)
                } else {
                    nicknameState = .enable
                    submitBtnState.accept(placeState)
                }
            }
            
            nicknameText.accept(name)
        }.disposed(by: disposeBag)
        
        input.endEditingNickname.bind { [weak self] name in
            guard let self = self, var new = name else { return }
            
            if new.removeLast() == " " {
                nicknameText.accept(new)
            } else {
                nicknameText.accept(name!)
            }
            
        }.disposed(by: disposeBag)
        
        let showPlaceList = PublishRelay<Void>()
        input.placeDidTap.bind(to: showPlaceList)
            .disposed(by: disposeBag)
        
        let selectPlace = PublishRelay<PlaceListResult>()
        input.selectedPlace.bind { [weak self] indexPath in
            guard let self = self else { return }
            selectPlace.accept(placeList.value[indexPath.row])
            
            placeState = .enable
            submitBtnState.accept(nicknameState)
        }.disposed(by: disposeBag)
        
        let resetPlace = PublishRelay<Void>()
        input.deletePlaceBtnDidTap.bind { [weak self] indexPath in
            guard let self = self else { return }
            resetPlace.accept(())
            
            placeState = .disable
            submitBtnState.accept(.disable)
        }.disposed(by: disposeBag)
        
        let showDatePicker = PublishRelay<Void>()
        input.dateDidTap.bind(to: showDatePicker).disposed(by: disposeBag)
        
        let selectDate = PublishRelay<IndexPath>()
        input.selectedDate.bind { [weak self] index in
            guard let self = self else { return }
            guard let newDay = Int(days.value[index.row]) else { return }
            
            var dateComponents = calendar.dateComponents([.year, .month], from: calendarDate)
            dateComponents.day = newDay
            
            guard let newDate = calendar.date(from: dateComponents) else { return }
            
            selectDate.accept(index)
            selectedDate.accept(dateToString(newDate))
            calendarDate = newDate
        }.disposed(by: disposeBag)
        
        input.previousMonthBtnDidTap
            .bind { [weak self] () in
                guard let self = self else { return }
                guard let preMonthDate = calendar.date(byAdding: .month, value: -1, to: calendarDate) else { return }
                
                calendarDate = preMonthDate
                currentMonth.accept(dateToMonthString(calendarDate))
                updateDays()
            }.disposed(by: disposeBag)
        
        input.nextMonthBtnDidTap
            .bind { [weak self] () in
                guard let self = self else { return }
                guard let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: calendarDate) else { return }
                
                calendarDate = nextMonthDate
                currentMonth.accept(dateToMonthString(calendarDate))
                updateDays()
            }.disposed(by: disposeBag)
        
        let cancleAddPlant = input.cancleBtnDidTap
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        let submitPlant = input.submitBtnDidTap
            .map { _ in ()
                // TODO: 네트워킹
                submitBtnState.accept(.onClick)
            }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(showImgSettingAlert: showImgSettingAlert.asDriver(onErrorJustReturn: ()),
                      showImagePicker: showImagePicker.asDriver(onErrorJustReturn: ()),
                      changeDefaultImage: changeDefaultImage.asDriver(onErrorJustReturn: ()),
                      nicknameText: nicknameText.asDriver(onErrorJustReturn: ""),
                      showPlaceList: showPlaceList.asDriver(onErrorJustReturn: ()),
                      selectPlace: selectPlace.asDriver(onErrorDriveWith: .empty()),
                      resetPlace: resetPlace.asDriver(onErrorJustReturn: ()),
                      showDatePicker: showDatePicker.asDriver(onErrorJustReturn: ()), selectDate: selectDate.asDriver(onErrorJustReturn: IndexPath()),
                      cancleAddPlant: cancleAddPlant,
                      submitPlant: submitPlant,
                      submitBtnState: submitBtnState.asDriver(onErrorJustReturn: .disable))
    }
}
