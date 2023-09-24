//
//  MemoViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/29.
//

import Foundation
import RxSwift

struct MemoViewModel {
    var memoObservable = BehaviorSubject<[Memo]>(value: [])
    
    init() {
        let memoList = [
        Memo(userNickName: "커먼플랜트", userImgURL: "https://firebasestorage.googleapis.com/v0/b/common-plant.appspot.com/o/01eda71b-0e68-1acd-8e39-b74e1fa53847?alt=media", content: "장마여서 물주는 날짜를 조금 늦춤 하지만 해는 맑구나 몬테랑 함께한 지 벌써 56일이 되었구나 요즘 잎이 갈라지니 채광이 더 드는 곳으로 자리를 옮겨야 할 것 같다.", imgURL: "https://commonplantbucket.s3.ap-northeast-2.amazonaws.com/1cc9b3dc-a5b6-4d33-992f-10f40b263e5f..jpg", createdAt: "2022.11.20"),
        Memo(userNickName: "커먼맘", userImgURL: "https://firebasestorage.googleapis.com/v0/b/common-plant.appspot.com/o/01eda71b-0e68-1acd-8e39-b74e1fa53847?alt=media", content: "오늘은 잎이 조금 시들하구나 커먼아 해결책은?", imgURL: nil, createdAt: "2020.11.20"),
        Memo(userNickName: "커먼맘", userImgURL: "https://commonplantbucket.s3.ap-northeast-2.amazonaws.com/1cc9b3dc-a5b6-4d33-992f-10f40b263e5f..jpg", content: "오늘은 잎의 상태가 매우 좋다 커먼아 앱에서 알려준 물주기의 주기가 아주 딱 맞는 것 같구나. 요즘 내가 물구기 누르는 거 자꾸 깜빡깜빡하니 커먼이 네가 조금 더 신경써주길 바란다.", imgURL: "https://commonplantbucket.s3.ap-northeast-2.amazonaws.com/1cc9b3dc-a5b6-4d33-992f-10f40b263e5f..jpg", createdAt: "2020.11.20"),
        Memo(userNickName: "커먼 파파", userImgURL: "https://firebasestorage.googleapis.com/v0/b/common-plant.appspot.com/o/01eda71b-0e68-1acd-8e39-b74e1fa53847?alt=media", content: "오늘도 맑음", imgURL: nil, createdAt: "2020.11.20")
        ]
        
        memoObservable.onNext(memoList)
    }
    
    func getMemoList() -> [Memo] {
        do {
            let memoList = try memoObservable.value()
            return memoList
        } catch {
            print("Error getting the value of memoList")
            return []
        }
    }
}
