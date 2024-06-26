//
//  NetworkError.swift
//  CommonPlant
//
//  Created by 이예원 on 6/26/24.
//

import Foundation

enum NetworkError: Error {
    case serverError
    case noInternetConnection
    case invalidToken
    case invalidURL
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case.serverError:
            return "서버 통신에 실패했습니다."
        case .noInternetConnection:
            return "인터넷 연결이 불안정합니다."
        case .invalidToken:
            return "로그인에 실패했습니다."
        case .invalidURL:
            return "서버에 문제가 발생했습니다."
        case .unknownError:
            return "일시적인 오류가 발생했습니다."
        }
    }
}
