//
//  AddPlantSecondViewController.swift
//  CommonPlant
//
//  Created by 아라 on 1/25/24.
//

import UIKit

class AddPlantSecondViewController: UIViewController {
    private let scrollView: UIView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    private let plantView: UIView = {
        let view = UIView()
        return view
    }()
    private let plantImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    private let cameraImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    private let nameBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .seaGreenLight
        return view
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyM1
        label.textColor = .gray4
        return label
    }()
    private let nameUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    private let nicknameView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let nicknameTextField: UITextField = {
        let tf = UITextField()
        tf.font = .bodyM1
        tf.textColor = .black
        tf.placeholder = "식물 애칭을 입력해주세요"
        tf.returnKeyType = .done
        return tf
    }()
    private let nicknameUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    private let nicknameCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/10"
        label.font = .captionB1
        label.textColor = .gray5
        label.partiallyChanged(targetString: "/10", font: .captionM1, color: .gray5)
        return label
    }()
    private let placeBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray1
        return view
    }()
    private let placeChoiceLabel: UILabel = {
        let label = UILabel()
        label.text = "장소 선택"
        label.font = .bodyM1
        label.textColor = .gray6
        return label
    }()
    private let nextImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    private let placeUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    private let placeCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: 250, height: 156)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return view
    }()
    private let dateView: UIView = {
        let view = UIView()
        return view
    }()
    private let lastWateredDayLabel: UILabel = {
        let label = UILabel()
        label.text = "마지막으로 물 준 날짜"
        label.font = .bodyM1
        label.textColor = .gray6
        return label
    }()
    private let datePickerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray1
        return view
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyM1
        label.textColor = .gray6
        return label
    }()
    private let dateUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    //private let datePicker
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "선택하지 않을 시, 등록일을 기준으로 설정합니다"
        label.font = .captionM2
        label.textColor = .seaGreen
        return label
    }()
    private let cancleButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attribute = AttributedString.init("취소")
        attribute.font = .bodyM3
        config.attributedTitle = attribute
        config.baseForegroundColor = .white
        config.background.cornerRadius = 4
        button.configuration = config
        button.backgroundColor = .gray5
        return button
    }()
    private let submitButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attribute = AttributedString.init("등록")
        attribute.font = .bodyM3
        config.attributedTitle = attribute
        config.baseForegroundColor = .white
        config.background.cornerRadius = 4
        button.configuration = config
        button.backgroundColor = .seaGreen
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
