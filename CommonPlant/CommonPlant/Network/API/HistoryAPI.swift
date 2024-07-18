//
//  HistoryAPI.swift
//  CommonPlant
//
//  Created by 이예원 on 7/8/24.
//

import Foundation
import Moya
import RxMoya
import RxSwift

class HistoryAPI {
    private let provider = MoyaProvider<HistoryService>()
    
    func fetchPopularWordList() -> Single<HistoryResponse> {
        return provider.rx.request(.fetchWordList)
            .map(HistoryResponse.self)
    }
}
