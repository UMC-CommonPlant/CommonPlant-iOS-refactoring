//
//  PlantService.swift
//  CommonPlant
//
//  Created by 아라 on 5/15/24.
//

import Foundation
import Moya

enum PlantService {
    case searchPlant(name: String)
    case fetchPlaceList
    case postPlant(request: PostPlantRequest)
    case fetchPlantDetail(idx: Int)
    case putPlant(request: PutPlantRequest)
    case deletePlant(idx: Int)
}

extension PlantService: BaseTargetType {
    var path: String {
        switch self {
        case .searchPlant(_):
            URLConstant.searchPlantWithWaterDay
        case .fetchPlaceList:
            URLConstant.placeList
        case .postPlant(_):
            URLConstant.postPlant
        case .fetchPlantDetail(let idx):
            URLConstant.getPlant + "/\(idx)"
        case .putPlant(let request):
            URLConstant.putPlant + "/\(request.plantIdx)"
        case .deletePlant(let idx):
            URLConstant.deletePlant + "/\(idx)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchPlant(_), .fetchPlantDetail(_), .fetchPlaceList:
            return .get
        case .postPlant(_):
            return .post
        case .putPlant(_):
            return .put
        case .deletePlant(_):
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .searchPlant(let name):
            return .requestParameters(parameters: ["name": name], encoding: URLEncoding.default)
        case .fetchPlaceList, .deletePlant(_):
            return .requestPlain
        case let .postPlant(request):
            var multiPartData: [Moya.MultipartFormData] = []
            
            let profileImageData = MultipartFormData(provider: .data(request.imageData), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
                multiPartData.append(profileImageData)
            
            let plant: [String: Any] = [
                "plantName" : request.plantName,
                "nickname" : request.nickname,
                "place" : request.place,
                "waterCycle" : request.waterCycle,
                "strWateredDate" : request.lastWateredDate
            ]
            
            if let plantData = try? JSONSerialization.data(withJSONObject: plant, options: []) {
                let plantFormData = MultipartFormData(provider: .data(plantData), name: "plant", fileName: "plant.json", mimeType: "application/json")
                multiPartData.append(plantFormData)
            }
            return .uploadMultipart(multiPartData)
        case .fetchPlantDetail(_):
            return .requestPlain
        case let .putPlant(request):
            var multiPartData: [Moya.MultipartFormData] = []
            
            let plantImageData = MultipartFormData(provider: .data(request.imageData), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            multiPartData.append(plantImageData)
            
            let plant: [String: Any] = [
                "plantIdx" : request.plantIdx,
                "nickname" : request.nickname,
                "waterCycle" : request.waterCycle
            ]
            
            if let plantData = try? JSONSerialization.data(withJSONObject: plant, options: []) {
                let plantFormData = MultipartFormData(provider: .data(plantData), name: "plant", fileName: "plant.json", mimeType: "application/json")
                multiPartData.append(plantFormData)
            }
            
            return .uploadMultipart(multiPartData)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .searchPlant(_):
            return NetworkConstant.noHeader
        case .fetchPlaceList, .deletePlant(_):
            return NetworkConstant.hasTokenHeader
        case .postPlant(_), .putPlant(_):
            var headers = NetworkConstant.hasMultipartHeader
            headers.merge(NetworkConstant.hasTokenHeader) { (_, new) in new }
            return headers
        case .fetchPlantDetail(_):
            return NetworkConstant.hasTokenHeader
        }
    }
}
