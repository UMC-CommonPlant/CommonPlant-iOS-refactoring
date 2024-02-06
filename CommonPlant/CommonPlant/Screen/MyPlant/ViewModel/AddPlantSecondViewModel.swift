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
    
    let placeList = BehaviorRelay<[Place]>(value: [])
    let selectedDate = BehaviorRelay<String>(value: "")
    let currentMonth = BehaviorRelay<String>(value: "")
    let days = BehaviorRelay<[String]>(value: [])
    var calendarDate = Date()
    
    init() {
        selectedDate.accept(dateToString(Date()))
        currentMonth.accept(dateToMonthString(Date()))
        updateDays()
        
        let list = [Place(placeImage: "", placeName: "스윗 홈_거실"),
        Place(placeImage: "https://commonplantbucket.s3.ap-northeast-2.amazonaws.com/ceb7bd36-86b4-4ab1-b2df-24862db128f8..jpg", placeName: "낫 스윗_회사")]
        placeList.accept(list)
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
        let startOfMonth = calendar.startOfDay(for: calendarDate)
        let weekdayOfFirstDay = calendar.component(.weekday, from: startOfMonth)
        guard let numberOfDays = calendar.range(of: .day, in: .month, for: calendarDate)?.count else { return }
        let empty = Array(repeating: "", count: weekdayOfFirstDay)
        let days = (1...numberOfDays).map { String($0) }

        self.days.accept(empty + days)
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
        let selectedCancle: Observable<Void>
        let editingNickname: Observable<String>
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
        let cancleSelectImage: Driver<Void>
        let nicknameState: Driver<String>
        let showPlaceList: Driver<Void>
        let selectPlace: Driver<String>
        let resetPlace: Driver<Void>
        let showDatePicker: Driver<Void>
        let cancleAddPlant: Driver<Void>
        let submitPlant: Driver<Void>
        let submitBtnState: Driver<SubmitState>
    }
    
    func transform(input: Input) -> Output {
        let submitBtnState = BehaviorRelay(value: SubmitState.disable)
        let showImgSettingAlert = input.imageDidTap
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        let showImagePicker = input.selectedNewImage
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        let changeDefaultImage = input.selectedDefaultImage
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        let cancleSelectImage = input.selectedCancle
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        let nicknameState = input.editingNickname
            .map { name in
                var name = name
                
                if name.contains("\n") {
                    name.removeLast()
                }
                
                if name.count > 10 {
                    let index = name.index(name.startIndex, offsetBy: 10)
                    name = String(name[..<index])
                }
                
                if name.count > 0 {
                    submitBtnState.accept(.enable)
                }
                
                return name
            }
            .asDriver(onErrorJustReturn: "")
        let showPlaceList = input.placeDidTap
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        let selectPlace = input.selectedPlace
            .map { index in
                // TODO: 해당 인덱스 장소 리턴하기
                return ""
            }
            .asDriver(onErrorJustReturn: "")
        let resetPlace = input.deletePlaceBtnDidTap
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        let showDatePicker = input.dateDidTap
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        
        input.selectedDate
            .bind { [weak self] index in
                guard let self = self else { return }
                guard let newDay = Int(days.value[index.row]) else { return }
                
                var dateComponents = calendar.dateComponents([.year, .month], from: calendarDate)
                dateComponents.day = newDay
                
                guard let newDate = calendar.date(from: dateComponents) else { return }
                
                selectedDate.accept(dateToString(newDate))
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
                guard let preMonthDate = calendar.date(byAdding: .month, value: 1, to: calendarDate) else { return }
                
                calendarDate = preMonthDate
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
        
        return Output(showImgSettingAlert: showImgSettingAlert,
               showImagePicker: showImagePicker,
               changeDefaultImage: changeDefaultImage,
               cancleSelectImage: cancleSelectImage,
               nicknameState: nicknameState,
               showPlaceList: showPlaceList,
               selectPlace: selectPlace,
               resetPlace: resetPlace,
               showDatePicker: showDatePicker,
               cancleAddPlant: cancleAddPlant,
               submitPlant: submitPlant,
               submitBtnState: submitBtnState.asDriver(onErrorJustReturn: .disable))
    }
}
