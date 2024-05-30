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
    case getPlaceList
    case postPlant(request: PostPlantRequest)
}

extension PlantService: BaseTargetType {
    var path: String {
        switch self {
        case .searchPlant(_):
            URLConstant.searchPlantWithWaterDay
        case .getPlaceList:
            URLConstant.placeList
        case .postPlant(_):
            URLConstant.postPlant
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchPlant(_), .getPlaceList:
            return .get
        case .postPlant(_):
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .searchPlant(let name):
            return .requestParameters(parameters: ["name": name], encoding: URLEncoding.default)
        case .getPlaceList:
            return .requestPlain
        case let .postPlant(request):
            var multiPartData: [Moya.MultipartFormData] = []
            
            if let profileImage = request.imageData {
                let profileImageData = MultipartFormData(provider: .data(profileImage), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
                multiPartData.append(profileImageData)
            }
            
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
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .searchPlant(_):
            return NetworkConstant.noHeader
        case .getPlaceList:
            return NetworkConstant.hasTokenHeader
        case .postPlant(_):
            var headers = NetworkConstant.hasMultipartHeader
            headers.merge(NetworkConstant.hasTokenHeader) { (_, new) in new }
            return headers
        }
    }
}
