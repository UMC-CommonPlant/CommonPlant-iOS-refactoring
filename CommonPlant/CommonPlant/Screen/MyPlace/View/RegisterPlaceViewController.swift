//
//  RegisterPlaceViewController.swift
//  CommonPlant
//
//  Created by 이예원 on 1/18/24.
//

import UIKit
import SnapKit
import Then

class RegisterPlaceViewController: UIViewController {
    // MARK: - Properties
    // MARK: - UI Components
    private let imagePickerButton = UIButton().then {
        let image = UIImage(named: "RegisterPlace")
        $0.setImage(image, for: .normal)
    }
    private let cameraImageView = UIImageView().then {
        $0.image = UIImage(named: "CameraMark")
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
    private let addressButton = UIButton().then {
        let image = UIImage(named: "Backspace")
        $0.setImage(image, for: .normal)
        $0.tintColor = .black
    }
    private let addressUnderlineView = UIView().then {
        $0.backgroundColor = .gray2
    }
    private let nextButton = CommonCTAButton(size: .large, color: .green).then {
        $0.text = "다음"
        $0.isDisabled = true
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addTargets()
    }
    
    
    // MARK: - Custom Method
    private func addTargets() {
        imagePickerButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
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
        [imagePickerButton, cameraImageView, placeNameTextField, countingLabel, placeNameUnderlineView, addressLabel, addressButton, addressUnderlineView, nextButton].forEach {
            view.addSubview($0)
        }
        
        imagePickerButton.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
        }
        
        cameraImageView.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.trailing.equalTo(imagePickerButton).offset(10)
            $0.bottom.equalTo(imagePickerButton).offset(10)
        }
        placeNameTextField.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalTo(imagePickerButton.snp.bottom).offset(48)
            $0.leading.equalToSuperview().offset(20)
        }
        
        countingLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(placeNameTextField)
        }
        
        placeNameUnderlineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(countingLabel.snp.bottom).offset(15)
        }
        
        addressLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(placeNameUnderlineView.snp.bottom).offset(48)
        }
        
        addressButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(addressLabel)
        }
        
        addressUnderlineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(addressButton.snp.bottom).offset(15)
        }
    
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    @objc private func buttonTapped() {
            print("Button tapped")
        }
}
