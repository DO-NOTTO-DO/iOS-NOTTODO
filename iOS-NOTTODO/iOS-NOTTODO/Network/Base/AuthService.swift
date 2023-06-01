//
//  AuthService.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/21.
//

import Foundation

import Moya

enum AuthService {
    case auth(social: String, socialToken: String, fcmToken: String, name: String, email: String)
}

extension AuthService: TargetType {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .auth(let social, _, _, _, _):
            return URLConstant.auth + "/\(social)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .auth:
            return .post
        }
    }
    var task: Moya.Task {
        switch self {
        case .auth(_, let socialToken, let fcmToken, let name, let email):
            return .requestParameters(parameters: ["socialToken": socialToken, "fcmToken": fcmToken, "name": name, "email": email],
                                      encoding: JSONEncoding.default)
        }
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
