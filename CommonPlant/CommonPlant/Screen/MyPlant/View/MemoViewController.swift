//
//  MemoViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/29.
//

import UIKit
import RxSwift
import RxCocoa

class MemoViewController: UIViewController {
    // MARK: - Properties
    var viewModel = MemoViewModel()
    let disposeBag = DisposeBag()
    let identifier = MemoCardCollectionViewCell.identifier
    
    // MARK: - UI Components
    lazy var memoCollectionView: UICollectionView = {let view = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        
        view.backgroundColor = .clear
        
        return view
    }()
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(100))
        let itme = NSCollectionLayoutItem(layoutSize: itemSize)
        // estimated를 사용하게 되면 contentInsets으로 조절하면 값이 무시가 됩니다.
        itme.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: nil)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [itme])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setMemoCollectionView()
    }
    
    // MARK: - Custom Methods
    func setMemoCollectionView() {
        memoCollectionView.backgroundColor = .gray1
        memoCollectionView.bounces = false
        
        self.view.addSubview(memoCollectionView)
        
        memoCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        memoCollectionView.register(MemoCardCollectionViewCell.self, forCellWithReuseIdentifier: MemoCardCollectionViewCell.identifier)
        
        viewModel.memoObservable
            .bind(to: memoCollectionView.rx.items(cellIdentifier: identifier, cellType: MemoCardCollectionViewCell.self)) { _, data, cell in
                cell.setAttributes(with: data)
            }
            .disposed(by: disposeBag)
    }
}
