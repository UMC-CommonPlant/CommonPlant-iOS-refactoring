//
//  RegisterPlaceViewModel.swift
//  CommonPlant
//
//  Created by 이예원 on 2/21/24.
//

import Foundation
import RxSwift
import RxCocoa
import Photos

class RegisterPlaceViewModel: ViewModelType {
    struct Input {
        let placeNameText: Observable<String?>
        let imagePickerButtonTapped: Observable<Void>
        let addressButtonTapped: Observable<Void>
    }
    
    struct Output {
        let isNextButtonEnabled: Observable<Bool>
        let cameraPermissionState: Driver<PHAuthorizationStatus>
        let navigateToPostCode: Driver<Void>
    }
    
    let addressLabelText = BehaviorSubject<String>(value: "")
    
    func transform(input: Input) -> Output {
        let cameraPermissionState = input.imagePickerButtonTapped
            .flatMapLatest { _ -> Observable<PHAuthorizationStatus> in
                Observable.create { observer in
                    ImagePickerViewModel.shared.checkPermissionState { status in
                        observer.onNext(status)
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
            }
            .asDriver(onErrorJustReturn: .notDetermined)
        
        let isNextButtonEnabled = Observable.combineLatest(input.placeNameText, addressLabelText)
            .map { placeNameText, addressText in
                return !(placeNameText?.isEmpty ?? true) && !addressText.isEmpty
            }
            .startWith(false)
        
        let navigateToPostCode = input.addressButtonTapped
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            isNextButtonEnabled: isNextButtonEnabled,
            cameraPermissionState: cameraPermissionState,
            navigateToPostCode: navigateToPostCode)
    }
    
    func updateAddressText(_ text: String) {
        addressLabelText.onNext(text)
    }
}
