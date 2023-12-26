//
//  Date+Extension.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/20/23.
//

import Foundation

extension Date {
    
    init?(year: Int, month: Int, day: Int) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        guard let date = Calendar.current.date(from: components) else {
            return nil
        }
        self = date
    }
    
    static var chatDataKeyFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM.dd E"
        
        return formatter
    }
    
    static var chatTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        
        return formatter
    }
    
    /// yyyy.MM.dd E
    var toChatDataKey: String {
        return Self.chatDataKeyFormatter.string(from: self)
    }
    
    var toChatTime: String {
        return Self.chatTimeFormatter.string(from: self)
    }
}
