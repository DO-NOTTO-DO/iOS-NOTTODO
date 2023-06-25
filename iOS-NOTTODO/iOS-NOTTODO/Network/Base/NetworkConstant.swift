//
//  NetworkConstant.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/23.
//

import Foundation

struct NetworkConstant {
    static let noTokenHeader = ["Content-Type": "application/json"]
    static var hasTokenHeader = ["Content-Type": "application/json",
                                 "Authorization": "\(KeychainUtil.getAccessToken())"]
}
