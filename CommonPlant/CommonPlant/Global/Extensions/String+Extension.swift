//
//  String+Extension.swift
//  CommonPlant
//
//  Created by 이예원 on 7/18/24.
//

import Foundation

extension String {
    func toFormattedDateString(from fromFormat: String, to toFormat: String) -> String? {
        let fromDateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = fromFormat
        
        guard let date = fromDateFormatter.date(from: self) else {
            return nil
        }
        
        let toDateFormatter = DateFormatter()
        toDateFormatter.dateFormat = toFormat
        
        return toDateFormatter.string(from: date)
    }
}
