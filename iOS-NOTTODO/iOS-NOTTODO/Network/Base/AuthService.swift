//
//  AuthService.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/21.
//

import Foundation

import Moya

enum AuthService {
    case auth(AuthRequest)
}

extension AuthService: TargetType {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .auth:
            return URLConstant.addMission
    }
    
    var method: Moya.Method {
        switch self {
        case .auth:
            return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .auth(let newAuth):
            return .requestParameters(
                parameters: newMission.toDictionary,
                encoding: JSONEncoding.default)
    }
    
    var headers: [String: String]? {
        switch self {
        case .auth:
            return NetworkConstant.hasTokenHeader
        }
    }
}

extension Encodable {
  var toDictionary: [String: Any] {
    guard let object = try? JSONEncoder().encode(self) else { fatalError() }
    guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else { fatalError() }
    return dictionary
  }
}

