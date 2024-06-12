//
//  MyPlantViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/24.
//

import Foundation
import RxSwift
import RxCocoa

class MyPlantViewModel {
    var myPlant = PublishRelay<PlantDetail>()
    let plantIdx: Int
    
    let disposeBag = DisposeBag()
    
    init(_ plantIdx: Int) {
        self.plantIdx = plantIdx
        
        PlantAPI.shared.getPlantDetail(index: plantIdx)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    myPlant.accept(response.result)
                    print(response.result)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }.disposed(by: self.disposeBag)
    }
}

extension MyPlantViewModel: ViewModelType {
    struct Input {
        let menuBtnDidTap: Observable<Void>
        let editBtnDidTap: Observable<Void>
        let deleteBtnDidTap: Observable<Void>
        let alertDeleteBtnDidTap: Observable<Void>
        let alertCancelBtnDidTap: Observable<Void>
        let backgroundViewDidTap: Observable<Void>
        let writeBtnDidTap: Observable<Void>
        let memoListDidTap: Observable<Void>
    }
    
    struct Output {
        let showMenu: Driver<Void>
        let showEditView: Driver<Int>
        let showDeleteAlert: Driver<Void>
        let backgroundHidden: Driver<Void>
        let showAddMemoView: Driver<Int>
        let showMemmoView: Driver<Int>
        let popToPreviousView: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let showMenu = input.menuBtnDidTap.asDriver(onErrorDriveWith: .empty())
        let showEditView = input.editBtnDidTap.map { [weak self] _ in
            guard let self else { return 0 }
            return plantIdx
        }.asDriver(onErrorJustReturn: 0)
        let showAddMemoView = input.writeBtnDidTap.map { [weak self] _ in
            guard let self else { return 0 }
            return plantIdx
        }.asDriver(onErrorJustReturn: 0)
        let showMemoView = input.memoListDidTap.map { [weak self] _ in
            guard let self else { return 0 }
            return plantIdx
        }.asDriver(onErrorJustReturn: 0)
        
        let showDeleteAlert = input.deleteBtnDidTap.asDriver(onErrorDriveWith: .empty())
        
        let backgroundHidden = PublishSubject<Void>()
        
        input.backgroundViewDidTap.bind(to: backgroundHidden)
            .disposed(by: disposeBag)
        
        input.alertCancelBtnDidTap.bind(to: backgroundHidden)
            .disposed(by: disposeBag)
        
        let popToPreviousView = PublishSubject<Void>()
        input.alertDeleteBtnDidTap.bind { _ in
            // TODO: 식물 삭제 API
            popToPreviousView.onNext(())
        }.disposed(by: disposeBag)
        
        
        return Output(showMenu: showMenu, showEditView: showEditView, showDeleteAlert: showDeleteAlert, backgroundHidden: backgroundHidden.asDriver(onErrorDriveWith: .empty()), showAddMemoView: showAddMemoView, showMemmoView: showMemoView, popToPreviousView: popToPreviousView.asDriver(onErrorJustReturn: ()))
    }
}
