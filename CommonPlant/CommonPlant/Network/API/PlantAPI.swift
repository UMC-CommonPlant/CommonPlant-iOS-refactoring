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
    
    func getPlaceListToAddPlant() -> Single<PlaceListResponse> {
        return provider.rx.request(.getPlaceList)
            .map(PlaceListResponse.self)
    }
    
    func addPlant(_ request: PostPlantRequest) -> Single<PostPlantResponse> {
        
        return provider.rx.request(.postPlant(request: request))
            .map(PostPlantResponse.self)
    }
    
    func getPlantDetail(index plantIdx: Int) -> Single<PlantDetailResponse> {
        return provider.rx.request(.getPlantDetail(idx: plantIdx))
            .map(PlantDetailResponse.self)
    }
    
    func putPlant(_ request: PutPlantRequest) -> Single<PutPlantResponse> {
        
        return provider.rx.request(.putPlant(request: request))
            .map(PutPlantResponse.self)
    }
    
    func deletePlant(index plantIdx: Int) -> Single<DeletePlantResponse> {
        return provider.rx.request(.deletePlant(idx: plantIdx))
            .map(DeletePlantResponse.self)
    }
}
