//
//  Formatter.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 5/12/24.
//

import Foundation

struct Formatter {
    static func dateFormatterString(format: String?, date: Date) -> String {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = format ?? "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        let convertStr = formatter.string(from: date)
        return convertStr
    }
}
