//
//  ViewModelType.swift
//  CommonPlant
//
//  Created by 이예원 on 2/21/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
 
    func transform(input: Input) -> Output
}
