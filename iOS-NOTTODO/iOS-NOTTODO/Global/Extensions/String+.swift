//
//  String+.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/06/07.
//

import Foundation

extension String {
    func toDate(withFormat format: String = "yyyy.MM.dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+00:00")
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
}
