//
//  PrivacyViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/27.
//

import UIKit
import RxSwift
import RxCocoa

class PrivacyViewModel {
    let disposeBag = DisposeBag()
    var isAgreePolicy = PublishRelay<Bool>()

    struct Input {
        let backBtnDidTap: Observable<Void>
        let agreeBtnDidTap: Observable<Bool>
        let doneBtnDidTap: Observable<Void>
    }
    
    struct Output {
        let dismiss: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let dismiss = PublishRelay<Void>()
        
        input.backBtnDidTap.bind(to: dismiss).disposed(by: disposeBag)
        
        input.doneBtnDidTap.subscribe { [weak self] _ in
            guard let self = self else { return }
            // TODO: 네트워킹
            
            dismiss.accept(())
        }.disposed(by: disposeBag)
        
        input.agreeBtnDidTap.bind { [weak self] isAgree in
            guard let self = self else { return }
            
            isAgreePolicy.accept(!isAgree)
        }.disposed(by: disposeBag)
        
        return Output(dismiss: dismiss.asDriver(onErrorDriveWith: .empty()))
    }
}
