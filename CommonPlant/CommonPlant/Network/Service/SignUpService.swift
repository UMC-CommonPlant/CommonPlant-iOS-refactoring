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
                let profileImageData = MultipartFormData(provider: .data(profileImage), name: "profileImage", fileName: "profileImage.jpeg", mimeType: "image/jpeg")
                multiPartData.append(profileImageData)
            }
            
            return .requestParameters(parameters: ["request": request], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
