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
    
   // static var accessToken = ""
    static var accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiLsoJXrkaXslrRAbm90dG9kby5jb20iLCJpYXQiOjE2ODQxNDM4ODAsImV4cCI6MTY4NjE0Mzg4MH0.B5mWTVA01jT24q9LIW01ZXhgweC7-UydQrfev9Iovh4"
}
