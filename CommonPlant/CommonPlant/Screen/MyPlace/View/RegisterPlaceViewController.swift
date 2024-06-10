//
//  RegisterPlaceViewController.swift
//  CommonPlant
//
//  Created by 이예원 on 1/18/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Photos

// TODO: - 장소 사진이 비율에 맞지 않게 들어가는 문제 해결하기

class RegisterPlaceViewController: UIViewController {
    // MARK: - UI Components
    private let imagePickerButton = UIButton().then {
        let image = UIImage(named: "RegisterPlace")
        $0.setImage(image, for: .normal)
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    private let cameraImageView = UIImageView().then {
        $0.image = UIImage(named: "CameraMark")
        $0.contentMode = .scaleAspectFill
    }
    private let placeNameTextField = UITextField().then {
        $0.placeholder = "장소의 이름을 입력해 주세요"
        $0.font = .bodyM1
        $0.textColor = .black
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .done
    }
    private let countingLabel = UILabel().then {
        $0.text = "0/10"
        $0.font = .captionB1
        $0.textColor = .gray5
        $0.textAlignment = .right
        $0.partiallyChanged(targetString: "/10", font: .captionM1, color: .gray5)
    }
    private let placeNameUnderlineView = UIView().then {
        $0.backgroundColor = .gray2
    }
    private let addressLabel = UILabel().then {
        $0.text = "주소"
        $0.font = .bodyM1
    }
    let roadAddressLabel = UILabel().then {
        $0.font = .bodyM1
        $0.textColor = .gray6
        $0.text = ""
    }
    private lazy var addressButton = UIButton().then {
        let image = UIImage(named: addressButtonImageName)
        $0.setImage(image, for: .normal)
    }
    private let addressUnderlineView = UIView().then {
        $0.backgroundColor = .gray2
    }
    private let nextButton = CommonCTAButton(size: .large, color: .green).then {
        $0.text = "다음"
        $0.isDisabled = true
    }
    
    // MARK: - Properties
    private let viewModel = RegisterPlaceViewModel()
    private let disposeBag = DisposeBag()
    private var addressButtonImageName = "Backspace"
    private let maxLength = 10
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        configurePlaceTextField()
    }
    
    // MARK: - Custom Method
    private func bind() {
        let input = RegisterPlaceViewModel.Input(
            placeNameText: placeNameTextField.rx.text.orEmpty
                .startWith("")
                .map { Optional($0) },
            imagePickerButtonTapped: imagePickerButton.rx.tap.asObservable(),
            addressButtonTapped: addressButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.showImageSettingAlert
            .drive(onNext: { [weak self] _ in
                self?.showImageSettingAlert { state in
                    switch state {
                    case .newImage:
                        self?.viewModel.checkCameraPermission()
                    case .defaultImage:
                        self?.setDefaultImage()
                    case .cancle:
                        break
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.cameraPermissionState
                   .drive(onNext: { [weak self] state in
                       print(state)
                       self?.subscribeToCameraPermissionState(output: output)
                   })
                   .disposed(by: disposeBag)
        
        output.isNextButtonEnabled
            .bind { [weak self] isEnabled in
                self?.nextButton.isEnabled = isEnabled
                self?.nextButton.isDisabled = !isEnabled
            }
            .disposed(by: disposeBag)
        
        addressButton.rx.tap
            .withLatestFrom(viewModel.addressLabelText)
            .subscribe(onNext: { [weak self] currentText in
                guard let self = self else { return }
                
                if !currentText.isEmpty {
                    self.viewModel.updateAddressText("")
                    self.addressButton.setImage(UIImage(named: "Backspace")?.withTintColor(.gray6!), for: .normal)
                } else {
                    self.showPostCodeViewController()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.addressLabelText
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.roadAddressLabel.text = text
                let imageName = text.isEmpty ? "Backspace" : "Delete"
                self?.addressUnderlineView.backgroundColor = text.isEmpty ? .gray2 : .black
                self?.addressButton.setImage(UIImage(named: imageName)?.withTintColor(.gray6!), for: .normal)
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigateToAddFriendViewController()
            })
            .disposed(by: disposeBag)
    }
    
    private func handleCameraPermissionState(_ state: PHAuthorizationStatus) {
        DispatchQueue.main.async {
            switch state {
            case .authorized:
                ImagePickerViewController.shared.showPhotoPicker(viewController: self)
                ImagePickerViewController.shared.didSelectImage = { [weak self] imageString in
                    self?.loadImage(imageString: imageString)
                }
            case .limited:
                let imagePickerVC = ImagePickerViewController()
                self.present(imagePickerVC, animated: true)
                imagePickerVC.didSelectImage = { [weak self] imageString in
                    self?.loadImage(imageString: imageString)
                }
            case .denied, .restricted:
                self.moveToSetting()
            default:
                break
            }
        }
    }
    
    private func subscribeToCameraPermissionState(output: RegisterPlaceViewModel.Output) {
        output.cameraPermissionState
            .drive(onNext: { [weak self] state in
                self?.handleCameraPermissionState(state)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadImage(imageString: String) {
        DispatchQueue.main.async { [weak self] in
            guard let url = URL(string: imageString),
                  let imageData = try? Data(contentsOf: url),
                  let image = UIImage(data: imageData) else { return }
            self?.imagePickerButton.setImage(image, for: .normal)
        }
    }
    
    private func setDefaultImage() {
        imagePickerButton.setImage(UIImage(named: "RegisterPlace"), for: .normal)
    }
    
    private func showPostCodeViewController() {
        let postCodeVC = PostCodeViewController()
        postCodeVC.onAddressSelect = { [weak self] address in
            self?.viewModel.updateAddressText(address)
            self?.addressButton.setImage(UIImage(named: "Delete")?.withTintColor(.gray3!), for: .normal)
        }
        present(postCodeVC, animated: true)
    }
    
    private func configurePlaceTextField() {
        placeNameTextField.rx.text.orEmpty
            .map { [weak self] text in
                return self?.truncateMaxLength(text: text) ?? ""
            }
            .observe(on: MainScheduler.instance)
            .do(onNext: { text in
                self.countingLabel.text = "\(text.count)/\(self.maxLength)"
                self.countingLabel.partiallyChanged(targetString: "/10", font: .captionM1, color: .gray5)
                self.placeNameUnderlineView.backgroundColor = text.isEmpty ? .gray2 : .black
            })
            .bind(to: placeNameTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func truncateMaxLength(text: String) -> String {
        return String(text.prefix(maxLength))
    }
    
    private func navigateToAddFriendViewController() {
        let addFriendVC = AddPlaceFriendViewController()
        self.navigationController?.pushViewController(addFriendVC, animated: true)
    }
}

extension RegisterPlaceViewController {
    private func configureUI() {
        self.view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        setConstraints()
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "장소 등록"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bodyB1, .foregroundColor: UIColor.gray6 as Any]
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func setConstraints() {
        [imagePickerButton, cameraImageView, placeNameTextField, countingLabel, placeNameUnderlineView, addressLabel, roadAddressLabel, addressButton, addressUnderlineView, nextButton].forEach {
            view.addSubview($0)
        }
        
        imagePickerButton.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
        }
        
        cameraImageView.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.right.bottom.equalTo(imagePickerButton).offset(10)
        }
        
        placeNameTextField.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalTo(imagePickerButton.snp.bottom).offset(48)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(countingLabel.snp.left).offset(-14)
        }
        
        countingLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(placeNameTextField)
        }
        
        placeNameUnderlineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(countingLabel.snp.bottom).offset(15)
        }
        
        addressLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(placeNameUnderlineView.snp.bottom).offset(48)
        }
        
        roadAddressLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.right.equalTo(addressButton.snp.left).offset(-8)
            $0.centerY.equalTo(addressButton)
        }
        
        addressButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(addressLabel)
        }
        
        addressUnderlineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(addressButton.snp.bottom).offset(15)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
    }
}
