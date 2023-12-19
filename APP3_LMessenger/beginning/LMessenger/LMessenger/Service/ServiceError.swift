//
//  ServiceError.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/14/23.
//

import Foundation

enum ServiceError: Error {
    case error(Error)
    case selfISNil
}
