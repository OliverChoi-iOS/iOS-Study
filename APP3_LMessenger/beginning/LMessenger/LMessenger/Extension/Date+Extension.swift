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
    
    static var chatDataAccessibilityFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 E"
        
        return formatter
    }
    
    static var chatTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        
        return formatter
    }
    
    static var chatTimeAccessibilityFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        
        return formatter
    }
    
    /// yyyy.MM.dd E
    var toChatDataKey: String {
        return Self.chatDataKeyFormatter.string(from: self)
    }
    
    var toChatDataAccessibility: String {
        return Self.chatDataAccessibilityFormatter.string(from: self)
    }
    
    var toChatTime: String {
        return Self.chatTimeFormatter.string(from: self)
    }
    
    var toChatTimeAccessibility: String {
        return Self.chatTimeAccessibilityFormatter.string(from: self)
    }
}

extension String {
    var toChatDate: Date? {
        return Date.chatDataKeyFormatter.date(from: self)
    }
}
