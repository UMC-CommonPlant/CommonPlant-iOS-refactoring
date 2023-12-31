//
//  ImagePickerViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/18.
//

import UIKit
import PhotosUI

class ImagePickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: Properties
    static let shared = ImagePickerViewController()
    let viewModel = ImagePickerViewModel()
    let identifier = ImagePickerCollectionViewCell.identifier
    var didSelectImage: ((String) -> Void)?
    
    // MARK: UIComponents
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = viewModel.minimumSpacing
        flowLayout.minimumInteritemSpacing = viewModel.minimumSpacing
        
        flowLayout.itemSize = viewModel.thumbnailSize
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

        view.setCollectionViewLayout(flowLayout, animated: true)
        return view
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadImages { [weak self] in
            self?.setUpCollectionView()
        }
    }
    
    // MARK: Custom Methods
    func setUpCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        collectionView.register(ImagePickerCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
    }
    
    // MARK: - UICollectionViewDelegate & UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        do {
            let accessImages = try viewModel.accessImageURLs.value()
            let imageCount = accessImages.count
            
            return imageCount
        } catch {
            print("Error getting the value of accessImageURLs")
            return 0
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ImagePickerCollectionViewCell

        do {
            let accessImages = try viewModel.accessImageURLs.value()
            let imageURL = accessImages[indexPath.row]
            
            cell.imageView.kf.setImage(with: imageURL)
        } catch {
            print("Error getting the value of accessImageURLs")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        
        do {
            let accessImages = try viewModel.accessImageURLs.value()
            let selectedImageURL = accessImages[indexPath.row]
           
            DispatchQueue.main.async {
                self.didSelectImage?(selectedImageURL.absoluteString)
            }
        } catch {
            print("Error getting the value of accessImageURLs")
        }
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ImagePickerViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        let itemProvider = results.first?.itemProvider

        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadFileRepresentation(forTypeIdentifier: "public.item") { (url, error) in
                if error != nil {
                    print("\(String(describing: error))")
                } else {
                    if let url = url {
                        self.didSelectImage?(url.absoluteString)
                    }
                }
            }
        }
    }
    
    func showPhotoPicker(viewController: UIViewController) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)

        picker.delegate = self

        viewController.present(picker, animated: true, completion: nil)
    }
}
