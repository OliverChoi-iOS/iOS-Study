//
//  NumericExtensions.swift
//  CProject
//
//  Created by Choi Oliver on 2/14/24.
//

import Foundation

extension Int {
    var moneyString: String {
        let formatter: NumberFormatter = .init()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return "\(formatter.string(for: self) ?? "")원"
    }
}
