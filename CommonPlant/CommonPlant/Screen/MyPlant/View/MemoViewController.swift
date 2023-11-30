//
//  MemoViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/29.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MemoViewController: UIViewController {
    // MARK: - Properties
    var viewModel = MemoViewModel()
    let identifier = MemoCardCollectionViewCell.identifier
    
    // MARK: - UI Components
    var backgroundView = UIView()
    var deleteAlertView: CommonAlertView = {
        let view = CommonAlertView()
        view.setTitle("게시물 삭제")
        view.setMessage("해당 게시물을 삭제하시겠습니까?")
        view.setActionButton(title: "삭제")
        view.isHidden = true
        return view
    }()
    var menuView: CommonMenuView = {
        let view = CommonMenuView()
        view.isHidden = true
        return view
    }()
    lazy var memoCollectionView: UICollectionView = {let view = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        
        view.backgroundColor = .clear
        
        return view
    }()
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(100))
        let itme = NSCollectionLayoutItem(layoutSize: itemSize)
        
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
        setBackgroundView()
    }
    
    // MARK: - Custom Methods
    func setBackgroundView() {
        backgroundView.backgroundColor = .black
        backgroundView.layer.opacity = 0.7
        backgroundView.isHidden = true
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setMemoCollectionView() {
        memoCollectionView.backgroundColor = .gray1
        memoCollectionView.bounces = false
        
        [memoCollectionView, backgroundView, menuView, deleteAlertView].forEach {
            view.addSubview($0)
        }
        
        memoCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        memoCollectionView.register(MemoCardCollectionViewCell.self, forCellWithReuseIdentifier: MemoCardCollectionViewCell.identifier)
        
        viewModel.memoObservable
            .bind(to: memoCollectionView.rx.items(cellIdentifier: identifier, cellType: MemoCardCollectionViewCell.self)) { id, data, cell in
                
                cell.moreButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        guard let self = self else { return }
                        print("moreButton is tapped.")
                        
                        self.backgroundView.isHidden = false
                        
                        self.showMenu(forCellAt: IndexPath(row: id, section: 0))
                    }).disposed(by: self.viewModel.disposeBag)
                
                cell.setAttributes(with: data)
            }.disposed(by: viewModel.disposeBag)
    }
    
    func showDeleteAlertView() {
        deleteAlertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(52.5)
            make.trailing.equalToSuperview().offset(-52.5)
            make.height.equalTo(148)
        }
        
        deleteAlertView.cancleButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            deleteAlertView.isHidden = true
            backgroundView.isHidden = true
        }).disposed(by: viewModel.disposeBag)
    }
    
    private func showMenu(forCellAt indexPath: IndexPath) {
        guard let cell = memoCollectionView.cellForItem(at: indexPath) as? MemoCardCollectionViewCell else { return }
        let moreButtonFrameInSuperview = cell.moreButton.convert(cell.moreButton.bounds, to: self.view)

        let menuTopOffset: CGFloat = 22
        let moreButtonBottomY = moreButtonFrameInSuperview.origin.y + moreButtonFrameInSuperview.height
        
        let menuTopY = menuTopOffset + moreButtonBottomY
        let menuViewHeight: CGFloat = 128
        let menuBottomY = menuTopY + menuViewHeight
        let bottomSafeAreaInset = self.view.safeAreaInsets.bottom
        let screenBottomY = self.view.bounds.height - bottomSafeAreaInset
        let necessaryScrollOffset = max(0, menuBottomY - screenBottomY)
        let scrollOffset: CGFloat = 4
        
        if necessaryScrollOffset > 0 {
            print("menuTopY: \(menuTopY), moreButtonBottomY: \(moreButtonBottomY), memoCollectionView.contentOffset.y: \(memoCollectionView.contentOffset.y)")
            UIView.animate(withDuration: 0.1) {
                let newOffset = self.memoCollectionView.contentOffset.y + necessaryScrollOffset + scrollOffset
                self.memoCollectionView.setContentOffset(CGPoint(x: 0, y: newOffset), animated: false)
            }
            
            self.menuView.snp.remakeConstraints { make in
                make.top.equalTo(menuTopY - necessaryScrollOffset - scrollOffset)
                make.trailing.equalTo(self.memoCollectionView.safeAreaLayoutGuide.snp.trailing).offset(-24)
                make.width.equalTo(228)
                make.height.equalTo(128)
            }
        } else {
            self.menuView.snp.remakeConstraints { make in
                make.top.equalTo(menuTopY)
                make.trailing.equalTo(self.memoCollectionView.safeAreaLayoutGuide.snp.trailing).offset(-24)
                make.width.equalTo(228)
                make.height.equalTo(128)
            }
        }

        menuView.editView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { gesture in
                // TODO: 메모 수정 로직
                self.menuView.isHidden = true
                self.backgroundView.isHidden = true
            }).disposed(by: viewModel.disposeBag)
        
        menuView.deleteView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { gesture in
                self.deleteAlertView.isHidden = false
                self.menuView.isHidden = true
                self.showDeleteAlertView()
            }).disposed(by: viewModel.disposeBag)
        
        menuView.isHidden = false
    }
}
