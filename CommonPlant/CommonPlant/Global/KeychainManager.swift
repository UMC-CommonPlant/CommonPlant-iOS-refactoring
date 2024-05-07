//
//  KeychainManager.swift
//  CommonPlant
//
//  Created by 아라 on 4/29/24.
//

import Foundation
import Security

final public class KeychainManager {
    static private let type = "accessToken"
    
    static func createToken(token: String) throws {
        let tokenData = token.data(using: .utf8)!
        
        let createQuery: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrType: type,
            kSecValueData: tokenData
        ]
        
        let status = SecItemAdd(createQuery as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("키체인 생성 성공")
        } else if status == errSecDuplicateItem {
            print("키체인 업데이트 예정")
            try updateToken(value: tokenData)
        } else {
            print("키체인 생성 실패")
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    static func read() throws -> String {
        let searchQuery: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrType: type,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        var result: CFTypeRef?
        
        let status = SecItemCopyMatching(searchQuery as CFDictionary, &result)
        
        guard status != errSecItemNotFound else {
            print("키체인 검색 결과 없음")
            throw KeychainError.notFound
        }
        
        guard status == errSecSuccess else {
            print("키체인 검색 실패")
            throw KeychainError.unhandledError(status: status)
        }
        
        guard let existingItem = result as? [String: Any],
              let tokenData = existingItem[kSecValueData as String] as? Data,
              let token = String(data: tokenData, encoding: .utf8)
        else {
            print("예상치 못한 데이터 반환")
            throw KeychainError.undexpectedData
        }
        
        return token
    }
    
    static private func updateToken(value: Data) throws {
        let originalQuery: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrType: type
        ]
        
        let updateQuery: [CFString: Any] = [
            kSecValueData: value
        ]
        
        let status = SecItemUpdate(originalQuery as CFDictionary, updateQuery as CFDictionary)
        
        if status == errSecSuccess {
            print("키체인 업데이트 성공")
        } else {
            print("키체인 업데이트 실패")
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    static func deleteToken() throws {
        let deleteQuery: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrType: type
        ]
        
        let status = SecItemDelete(deleteQuery as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound
        else {
            print("KeychainError.unhandledError")
            throw KeychainError.unhandledError(status: status)
        }
        
        print("키체인 삭제 성공")
    }
}

enum KeychainError: Error {
    case notFound // 키체인 찾을 수 없음
    case undexpectedData // 예상치 못한 데이터
    case unhandledError(status: OSStatus) // 예외 처리에 실패한 에러
}
