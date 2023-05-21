//
//  AuthRequestDTO.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/21.
//

import Foundation

struct AuthRequestDTO: Encodable {
    let socialToken: String
    let fcmToken: String
    let name: String // apple
    let email: String // test
}
