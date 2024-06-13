//
//  AddFriendsToPlaceViewModel.swift
//  CommonPlant
//
//  Created by 이예원 on 6/11/24.
//

import Foundation
import RxSwift
import RxCocoa

class AddFriendsToPlaceViewModel: ViewModelType {
    struct Input {
        let selectFriend: PublishRelay<String>
        let deselectFriend: PublishRelay<String>
    }
    
    struct Output {
        let friends: BehaviorRelay<[String]>
        let selectedFriends: BehaviorRelay<[String]>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let friends = BehaviorRelay(value: ["친구1", "친구2", "친구3", "친구4", "친구5"]) 
        let selectedFriends = BehaviorRelay(value: [String]())
        
        input.selectFriend
            .withLatestFrom(selectedFriends) { (friend, selected) -> [String] in
                var newSelection = selected
                if !newSelection.contains(friend) {
                    newSelection.append(friend)
                }
                return newSelection
            }
            .bind(to: selectedFriends)
            .disposed(by: disposeBag)
        
        input.deselectFriend
            .withLatestFrom(selectedFriends) { (friend, selected) -> [String] in
                let newSelection = selected.filter { $0 != friend }
                return newSelection
            }
            .bind(to: selectedFriends)
            .disposed(by: disposeBag)
        
        return Output(friends: friends, selectedFriends: selectedFriends)
    }
}


