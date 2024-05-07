//
//  SignUpService.swift
//  CommonPlant
//
//  Created by 아라 on 4/17/24.
//

import UIKit
import Moya

enum SignUpService {
    case duplicateNickname(nickname: String)
    case postUser(request: PostUserRequest)
}

extension SignUpService: BaseTargetType {
    var path: String {
        switch self {
        case let .duplicateNickname(nickname):
            URLConstant.getDuplicateNickname + "/\(nickname)/exists"
        case .postUser:
            URLConstant.postUser
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .duplicateNickname(_) :
            return .get
        case .postUser(_):
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .duplicateNickname :
            return .requestPlain
        case let .postUser(request) :
            var multiPartData: [Moya.MultipartFormData] = []
            
            if let profileImage = request.imgData {
                let profileImageData = MultipartFormData(provider: .data(profileImage), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
                multiPartData.append(profileImageData)
            }
            
            let user: [String: Any] = [
                "email" : request.email,
                "name" : request.name,
                "provider" : request.provider
            ]
            
            if let userData = try? JSONSerialization.data(withJSONObject: user, options: []) {
                let userFormData = MultipartFormData(provider: .data(userData), name: "user", fileName: "user.json", mimeType: "application/json")
                multiPartData.append(userFormData)
            }
            return .uploadMultipart(multiPartData)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .duplicateNickname(_):
            return NetworkConstant.noHeader
        case .postUser(_):
            return NetworkConstant.hasMultipartHeader
        }
    }
}
