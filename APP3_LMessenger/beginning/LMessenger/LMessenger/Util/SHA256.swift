//
//  SHA256.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/19/23.
//

import Foundation
import CryptoKit

func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}
