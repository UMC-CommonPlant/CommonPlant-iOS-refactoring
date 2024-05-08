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
        let showImageSettingAlert: Driver<Void>
        let navigateToPostCode: Driver<Void>
    }
    
    private let cameraPermissionStateSubject = PublishSubject<PHAuthorizationStatus>()

    let addressLabelText = BehaviorSubject<String>(value: "")
    
    func transform(input: Input) -> Output {
        let showImageSettingAlert = input.imagePickerButtonTapped
                    .do(onNext: { [weak self] _ in
                        self?.checkCameraPermission()
                    })
                    .asDriver(onErrorDriveWith: Driver.empty())
        
        let cameraPermissionState = cameraPermissionStateSubject
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
            showImageSettingAlert: showImageSettingAlert,
            navigateToPostCode: navigateToPostCode)
    }
    
    private func checkCameraPermission() {
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                self?.cameraPermissionStateSubject.onNext(status)
            }
        }

    
    func updateAddressText(_ text: String) {
        addressLabelText.onNext(text)
    }
}
