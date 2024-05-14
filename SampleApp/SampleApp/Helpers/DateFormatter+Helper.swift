//
//  DateFormatter+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 16.02.24.
//

import Foundation

extension DateFormatter {
    static var shortDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .init(secondsFromGMT:0)
        
        return formatter
    }
}

extension Date {
    var remainingTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM:SS"
        return formatter.string(from: self)
    }
    
    static func timeDifference(from start: Date = .now, to end: Date, components: Set<Calendar.Component> = [.hour, .minute, .second]) -> DateComponents {
        Calendar.current.dateComponents(components, from: start, to: end)
    }
    
    var isPastEvent: Bool {
        guard let hoursPast = Self.timeDifference(from: .now, to: self).hour else { return true }
        return hoursPast <= -2
    }
}

extension TimeInterval {
    var asDate: Date { .init(timeIntervalSince1970: self) }
}

extension Int {
    var asDate: Date { Double(self).asDate }
}
