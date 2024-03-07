//
//  CalendarViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 3/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class CalendarViewModel {
    let disposeBag = DisposeBag()
    let calendar = Calendar.current
    let todayDate = Date()
    var selectedDate = Date()
    var calendarDate = Date()
    
    let currentMonth = BehaviorRelay<String>(value: "")
    let days = BehaviorRelay<[String]>(value: [])
    let placeList = BehaviorRelay<[CalendarPlace]>(value: [])
    let plantList = BehaviorRelay<[CalendarPlant]>(value: [])
    let messageList = BehaviorRelay<[String]>(value: [])
    let memoList = BehaviorRelay<[CalendarMemo]>(value: [])
    
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
    
    func checkSelectedDay(day: String) -> Bool {
        guard let day = Int(day) else { return false }
        guard let newDate = calendar.date(bySetting: .day, value: day, of: calendarDate) else { return false }
        
        let selectedComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let newDateComponents = calendar.dateComponents([.year, .month, .day], from: newDate)
        
        return selectedComponents == newDateComponents
    }
}

extension CalendarViewModel {
    struct Input {
        let wholeMonthBtnDidTap: Observable<Void>
        let selectedMonth: Observable<Date>
        let previousMonthBtnDidTap: Observable<Void>
        let nextMonthBtnDidTap: Observable<Void>
        let selectedDate: Observable<IndexPath>
        let selectedPlace: Observable<IndexPath>
        let selectedPlant: Observable<IndexPath>
        let selectedMemo: Observable<IndexPath>
    }
    
    struct Output {
        let showWholeMonth: Driver<Void>
        let selectedDate: Observable<Void>
        let showMemoDetail: Driver<IndexPath>
    }
    
    func transform(input: Input) -> Output {
        let showWholeMonth = PublishRelay<Void>()
        input.wholeMonthBtnDidTap.bind(to: showWholeMonth).disposed(by: disposeBag)
        
        input.selectedMonth.subscribe { [ weak self ] date in
            guard let self = self else { return }
            
            calendarDate = date
            currentMonth.accept(dateToMonthString(calendarDate))
            updateDays()
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
        
        let selectDate = PublishRelay<Void>()
        input.selectedDate.bind { [weak self] index in
            guard let self = self else { return }
            guard let newDay = Int(days.value[index.row]) else { return }
            
            var dateComponents = calendar.dateComponents([.year, .month], from: calendarDate)
            dateComponents.day = newDay
            
            guard let newDate = calendar.date(from: dateComponents) else { return }
            
            selectDate.accept(())
            selectedDate = newDate
        }.disposed(by: disposeBag)
        
        input.selectedPlace.subscribe { [weak self] indexPath in
            guard let self = self else { return }
            
            // TODO: 식물 리스트 업데이트
            // TODO: 첫번째 식물을 기준으로 메세지와 메모 리스트 업데이트
        }.disposed(by: disposeBag)

        input.selectedPlant.subscribe { [weak self] indexPath in
            guard let self = self else { return }
            
            // TODO: 메세지와 메모 리스트 업데이트
        }.disposed(by: disposeBag)
        
        let showMemoDetail = PublishRelay<IndexPath>()
        input.selectedMemo.subscribe { [weak self] indexPath in
            guard let self = self else { return }
            
            showMemoDetail.accept(indexPath)
        }.disposed(by: disposeBag)
        
        return Output(showWholeMonth: showWholeMonth.asDriver(onErrorJustReturn: ()),
                      selectedDate: selectDate.asObservable(),
                      showMemoDetail: showMemoDetail.asDriver(onErrorDriveWith: .empty()))
    }
}
