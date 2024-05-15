//
//  PlantAPI.swift
//  CommonPlant
//
//  Created by 아라 on 5/15/24.
//

import Foundation
import Moya
import RxMoya
import RxSwift

class PlantAPI {
    static let shared = PlantAPI()
    let provider: MoyaProvider<PlantService>
    let disposeBag = DisposeBag()
    
    init( _ provider: MoyaProvider<PlantService> = MoyaProvider<PlantService>(plugins: [NetworkLogger()])) {
        self.provider = provider
    }
    
    func searchPlant(target name: String) -> Single<SearchPlantResponse> {
        return provider.rx.request(.searchPlant(name: name))
            .map(SearchPlantResponse.self)
    }
}
