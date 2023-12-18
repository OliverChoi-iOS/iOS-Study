//
//  DBError.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/18/23.
//

import Foundation

enum DBError: Error {
    case error(Error)
    case emptyValue
}
