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

extension SignUpService: TargetType {
    var baseURL: URL {
        guard let baseString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String,
              let baseURL = URL(string: baseString) else { fatalError("유효하지 않는 서버 URL입니다.") }
        
        return baseURL
    }
    
    var path: String {
        switch self {
        case let .duplicateNickname(nickname):
            "/user/\(nickname)/exists"
        case .postUser:
            "/user"
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
            return nil
        case .postUser(_):
            return ["Content-Type" : "multipart/form-data"]
        }
    }
}
