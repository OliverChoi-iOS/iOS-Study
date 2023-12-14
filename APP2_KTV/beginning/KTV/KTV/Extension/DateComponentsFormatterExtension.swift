//
//  DateComponentsFormatterExtension.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/17.
//

import Foundation

extension DateComponentsFormatter {
    static let playTimeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        
        return formatter
    }()
}
