//
//  ViewController2.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/07/06.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1)
       // self.view.backgroundColor = .red
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
  
    func configureUI() {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1)
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(4)
        }
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.backgroundColor = .white
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView)
        }
        
        let topView = UIView()
        contentView.addSubview(topView)
        topView.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1)
        topView.snp.makeConstraints {
            $0.top.left.right.equalTo(contentView)
            $0.height.equalTo(200)
        }
        
        let userNameLabel = UILabel()
        topView.addSubview(userNameLabel)
        userNameLabel.text = "커먼"
        userNameLabel.textColor = UIColor(red: 0.3, green: 0.37, blue: 0.35, alpha: 1)
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(46)
            $0.left.equalTo(contentView).offset(20)
            $0.height.equalTo(22)
        }
        
        let label1 = UILabel()
        topView.addSubview(label1)
        label1.text = "님과 함께 친환경 한 걸음을"
        label1.textColor = .black
        label1.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(6)
            $0.left.equalTo(contentView).offset(20)
            $0.height.equalTo(24)
        }
        
        let label2 = UILabel()
        topView.addSubview(label2)
        label2.text = "한걸음에"
        label2.textColor = .seaGreenDark3
        label2.snp.makeConstraints {
            $0.top.equalTo(label1.snp.bottom).offset(6)
            $0.left.equalTo(contentView).offset(20)
            $0.height.equalTo(24)
        }
        
        let label2Shadowview = UIView()
        topView.insertSubview(label2Shadowview, at: 0)
        label2Shadowview.backgroundColor = UIColor(red: 0.3, green: 0.37, blue: 0.35, alpha: 0.16)
        label2Shadowview.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(20)
            $0.height.equalTo(10)
            $0.width.equalTo(70)
            $0.bottom.equalTo(label2)
        }
        
        let gradientView = UIView()
        topView.addSubview(gradientView)
        gradientView.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(27.6)
            $0.bottom.equalTo(topView.snp.bottom).offset(-11)
        }
        
        view.layoutIfNeeded()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        let colors: [CGColor] = [
            UIColor(red: 0.85, green: 0.87, blue: 0.87, alpha: 0.6).cgColor,
            UIColor(red: 0.85, green: 0.87, blue: 0.87, alpha: 0).cgColor
        ]
        gradientLayer.colors = colors
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientView.layer.masksToBounds = true
        gradientView.layer.addSublayer(gradientLayer)
        
        let potImageView = UIImageView()
        topView.addSubview(potImageView)
        potImageView.image = UIImage(named: "mainPodImg")
        potImageView.snp.makeConstraints {
            $0.right.equalTo(topView.snp.right).offset(-23)
            $0.bottom.equalTo(topView.snp.bottom).offset(-26)
            $0.height.equalTo(64)
            $0.width.equalTo(88)
        }
        

        let sampleLabel = UILabel()
        contentView.addSubview(sampleLabel)
        sampleLabel.text = "Lorem ipsum dolor sit amet "
        sampleLabel.numberOfLines = 0
        sampleLabel.snp.makeConstraints {
            $0.left.right.equalTo(contentView).inset(20)
            $0.top.equalTo(topView.snp_bottomMargin)
            $0.top.bottom.equalTo(contentView).offset(20)
        }

        
    }
}
