//
//  Date+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 06/02/2024.
//

import Foundation

enum DateFormatterType {
    case ddMMyyyy
    case yyyyMMdd
    case yyyyMMddThhmmss

    var value: String {
        switch(self) {
        case .ddMMyyyy:
            return "dd/MM/yyyy"
        case .yyyyMMdd:
            return "yyyy-MM-dd"
        case .yyyyMMddThhmmss:
            return "yyyy-MM-dd'T'HH:mm:ssZ"
        }
    }
}

extension Date {

    init?(fromString string: String, formatter: DateFormatterType) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter.value
        if let date = dateFormatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }

    func toString(formatter: DateFormatterType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter.value
        return dateFormatter.string(from: self)
    }

    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
