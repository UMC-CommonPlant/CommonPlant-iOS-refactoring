//
//  NetworkErrorResponse.swift
//  CommonPlant
//
//  Created by 이예원 on 6/26/24.
//

import Foundation

struct NetworkErrorResponse: Codable {
    let timeStamp: String
    let code: Int
    let message: String
    let success: Bool
}
