//
//  NetworkConstant.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/23.
//

import Foundation

struct NetworkConstant {
    static let noTokenHeader = ["Content-Type": "application/json"]
    static let hasTokenHeader = ["Content-Type": "application/json",
                                 "Authorization": NetworkConstant.accessToken]
    
    static var accessToken = ""
}
