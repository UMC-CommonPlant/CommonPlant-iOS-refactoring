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
    var myPlant: MyPlant
    let plantIdx: Int
    
    let disposeBag = DisposeBag()
    
    init(_ plantIdx: Int) {
        self.plantIdx = plantIdx
        let plant = MyPlant(
            nickname: "몬테", scientificName: "Monstera deliciosa", place: "스윗홈_거실",
            imgURL: "https://commonplantbucket.s3.ap-northeast-2.amazonaws.com/f2e8f083-56aa-4952-8f1e-d07160c21036..jpg",
            countDate: 1, remainderDate: -3, createdAt: "2022.11.24", wateredDate: "2022.11.24", waterDay: 10, sunlight: "밝은곳을 좋아해요!", tempMin: 16, tempMax: 20, humidity: "70% 이상",
            memoList: [
                Memo(userNickName: "커먼플랜트", userImgURL: "https://firebasestorage.googleapis.com/v0/b/common-plant.appspot.com/o/01eda71b-0e68-1acd-8e39-b74e1fa53847?alt=media", content: "장마여서 물주는 날짜를 조금 늦춤 하지만 해는 맑구나 몬테랑 함께...", imgURL: "https://firebasestorage.googleapis.com/v0/b/common-plant.appspot.com/o/01eda71b-0e68-1acd-8e39-b74e1fa53847?alt=media", createdAt: "2022.11.20"),
                Memo(userNickName: "커먼맘", userImgURL: "https://firebasestorage.googleapis.com/v0/b/common-plant.appspot.com/o/01eda71b-0e68-1acd-8e39-b74e1fa53847?alt=media", content: "오늘은 잎이 조금 시들하구나 커먼아 해결책은?", imgURL: "https://firebasestorage.googleapis.com/v0/b/common-plant.appspot.com/o/commonPlant_plant/몬테_fgbdLj?alt=media", createdAt: "2022.11.20")
            ])
        
        myPlant = plant
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
