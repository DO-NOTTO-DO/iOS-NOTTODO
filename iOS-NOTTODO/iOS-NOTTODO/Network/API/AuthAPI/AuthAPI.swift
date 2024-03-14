//
//  AuthAPI.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/21.
//

import Foundation

import Moya

struct AuthRequest: Codable {
    let socialToken: String
    let fcmToken: String
    var name: String?
}

enum AuthAPI {
    case kakaoAuth(social: LoginType, request: AuthRequest)
    case appleAuth(social: LoginType, request: AuthRequest)
    case logout
    case withdrawal
}

extension AuthAPI: BaseAPI {
    var domain: BaseDomain {
        return .auth
    }
    
    var urlPath: String {
        switch self {
        case .kakaoAuth(let social, _), .appleAuth(let social, _):
            return URLConstant.auth + "/\(social.rawValue)"
        case .logout:
            return URLConstant.authLogout
        case .withdrawal:
            return URLConstant.authWithdrawal
        }
    }
    
    var headerType: HeaderType {
        
        switch self {
        case .kakaoAuth, .appleAuth:
            return .json
        case .logout, .withdrawal:
            return .jsonWithToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoAuth, .appleAuth:
            return .post
        case .logout, .withdrawal:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .kakaoAuth(_, let data):
            return .requestJSONEncodable(data)
        case .appleAuth(_, let data):
            return .requestJSONEncodable(data)
        case .logout, .withdrawal:
            return .requestPlain
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
