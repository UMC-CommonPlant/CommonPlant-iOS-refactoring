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
}
