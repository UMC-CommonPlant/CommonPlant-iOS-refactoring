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
    
    static func thisMonthFirstDayString(format: String = "yyyy.M.d") -> String {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: now)
        let startOfMonth = calendar.date(from: components)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: startOfMonth)
    }
}
