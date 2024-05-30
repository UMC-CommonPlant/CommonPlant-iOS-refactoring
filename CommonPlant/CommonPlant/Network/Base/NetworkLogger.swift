//
//  NetworkLogger.swift
//  CommonPlant
//
//  Created by 아라 on 4/23/24.
//

import Foundation
import Moya

final class NetworkLogger: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        #if DEBUG
        print("\n————— [REQUEST] —————\n")
        print("API Endpoint : \(target.baseURL.absoluteString + target.path)")
        print("Headers : \(target.headers ?? [:])")
        print("Task : \(target.task)")
        print("————————————————\n")
        #endif
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        #if DEBUG
        switch result {
        case let .success(response):
            guard let httpURLResponse = response.response else {
                break
            }
            print("\n————— [RESPONSE] —————\n")
            print("API Endpoint : \(target.baseURL.absoluteString + target.path)")
            print("Headers : \(httpURLResponse.allHeaderFields)")

            if let responseString = String(data: response.data, encoding: .utf8) {
                print("Response String : \(responseString)")

                if let json = try? JSONSerialization.jsonObject(with: response.data, options: []) {
                    print("Response JSON : \(json)")
                } else {
                    print("Response is not a valid JSON")
                }
            } else {
                print("Unable to decode response data as a string")
            }
            print("————————————————\n")
            
        case let .failure(error):
            print("\n————— [ERROR RESPONSE] —————\n")
            print("API Endpoint : \(target.baseURL.absoluteString + target.path)")
            print("Headers : \(target.headers ?? [:])")
            print("Task : \(target.task)")
            print("Error : \(error)")
            if let responseData = error.response?.data {
                let responseString = String(data: responseData, encoding: .utf8) ?? "Unable to decode response"
                print("Raw Response : \(responseString)")
            }
            print("————————————————\n")
        }
        #endif
    }
}
