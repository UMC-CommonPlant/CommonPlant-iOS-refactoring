//
//  ImagePickerViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/18.
//

import Foundation
import RxSwift
import RxCocoa
import PhotosUI

class ImagePickerViewModel {
    static let shared = ImagePickerViewModel()

    var fetchResult = PHFetchResult<PHAsset>()
    var accessImageURLs: BehaviorSubject<[URL]> = BehaviorSubject(value: [])
    var cellItemForRow: CGFloat = 3
    var minimumSpacing: CGFloat = 2

    var thumbnailSize: CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let length = (screenWidth - (cellItemForRow - 1) * minimumSpacing) / cellItemForRow
        return CGSize(width: length, height: length)
    }
    
    func loadImages(completion: @escaping () -> Void) {
        self.accessImageURLs = BehaviorSubject(value: [])
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        let fetchGroup = DispatchGroup()
        
        fetchResult.enumerateObjects { (asset, _, _) in
            fetchGroup.enter()
            self.getURL(ofPhotoWith: asset) { imageUrl in
                if let imageUrl = imageUrl {
                    do {
                        var tempURLs = try self.accessImageURLs.value()
                        tempURLs.append(imageUrl)
                        self.accessImageURLs.onNext(tempURLs)
                        
                        fetchGroup.leave()
                    } catch {
                        print("Error getting the value of accessImageURLs")
                    }
                }
            }
        }
        
        fetchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func getURL(ofPhotoWith mPhasset: PHAsset, completionHandler : @escaping ((_ responseURL : URL?) -> Void)) {
        let options = PHContentEditingInputRequestOptions()
        options.canHandleAdjustmentData = { _ in return true }
        mPhasset.requestContentEditingInput(with: options, completionHandler: { input, info in
            if let url = input?.fullSizeImageURL {
                completionHandler(url)
            } else {
                completionHandler(nil)
            }
        })
    }
    
    func checkPermissionState(completion: @escaping (PHAuthorizationStatus) -> Void) {
        let requiredAccessLevel: PHAccessLevel = .readWrite
        PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { authorizationStatus in
            completion(authorizationStatus)
        }
    }
}
