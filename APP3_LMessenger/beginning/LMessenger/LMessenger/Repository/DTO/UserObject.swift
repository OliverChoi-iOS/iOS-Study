//
//  UserObject.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/18/23.
//

import Foundation

struct UserObject: Codable {
    var id: String
    var name: String
    var phoneNumber: String?
    var profileURL: String?
    var descripton: String?
}

extension UserObject {
    func toModel() -> User {
        .init(
            id: id,
            name: name,
            phoneNumber: phoneNumber,
            profileURL: profileURL,
            descripton: descripton
        )
    }
}
