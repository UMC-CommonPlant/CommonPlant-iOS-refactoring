//
//  MyPlantViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/24.
//

import Foundation
import RxSwift

class MyPlantViewModel {
    var myPlant: MyPlant
    
    init() {
        let plant = MyPlant(
            nickname: "몬테", scientificName: "Monstera deliciosa", place: "스윗홈_거실",
            imgURL: "https://firebasestorage.googleapis.com/v0/b/common-plant.appspot.com/o/commonPlant_plant/몬테_fgbdLj?alt=media",
            countDate: 1, remainderDate: -3, createdAt: "2022.11.24", wateredDate: "2022.11.24", waterDay: 10, sunlight: "밝은곳을 좋아해요!", tempMin: 16, tempMax: 20, humidity: "70% 이상",
            memoList: [
                Memo(userNickName: "커먼플랜트", userImgURL: "https://firebasestorage.googleapis.com/v0/b/common-plant.appspot.com/o/01eda71b-0e68-1acd-8e39-b74e1fa53847?alt=media", content: "장마여서 물주는 날짜를 조금 늦춤 하지만 해는 맑구나 몬테랑 함께...", imgURL: "https://firebasestorage.googleapis.com/v0/b/common-plant.appspot.com/o/01eda71b-0e68-1acd-8e39-b74e1fa53847?alt=media", createdAt: "2022.11.20"),
                Memo(userNickName: "커먼맘", userImgURL: "https://firebasestorage.googleapis.com/v0/b/common-plant.appspot.com/o/01eda71b-0e68-1acd-8e39-b74e1fa53847?alt=media", content: "오늘은 잎이 조금 시들하구나 커먼아 해결책은?", imgURL: "https://firebasestorage.googleapis.com/v0/b/common-plant.appspot.com/o/commonPlant_plant/몬테_fgbdLj?alt=media", createdAt: "2022.11.20")
            ])
        
        myPlant = plant
    }
}
