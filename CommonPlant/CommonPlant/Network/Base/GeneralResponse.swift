//
//  GeneralResponse.swift
//  CommonPlant
//
//  Created by 아라 on 5/7/24.
//

import Foundation

struct GeneralResponse<T: Codable>: Codable {
    let timeStamp: String
    let status: Int
    let success: Bool
    let message: String
    let result: T?
    
    enum CodingKeys: String, CodingKey {
        case timeStamp
        case status
        case success
        case message
        case result
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        timeStamp = (try? values.decode(String.self, forKey: .timeStamp)) ?? ""
        status = (try? values.decode(Int.self, forKey: .status)) ?? 0
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        result = (try? values.decode(T.self, forKey: .result)) ?? nil
    }
}
