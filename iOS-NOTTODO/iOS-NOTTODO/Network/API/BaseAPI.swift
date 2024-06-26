//
//  BaseAPI.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/14/24.
//

import Foundation

import Moya

enum BaseDomain {
    case auth
    case mission
    case recommend
}

extension BaseDomain {
    
    var url: String {
        switch self {
        case .auth:
            return "/auth"
        case .mission:
            return "/mission"
        case .recommend:
            return "/recommend"
        }
    }
}

protocol BaseAPI: TargetType {
    var domain: BaseDomain { get }
    var urlPath: String { get }
    var headerType: HeaderType { get }
}

extension BaseAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var path: String {
        return domain.url + urlPath
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var headers: [String: String]? {
        return headerType.value
    }
}

public enum HeaderType {
    case json
    case jsonWithToken
    
    public var value: [String: String] {
        switch self {
        case .json:
            return ["Content-Type": "application/json"]
        case .jsonWithToken:
            return ["Content-Type": "application/json",
                    "Authorization": "\(KeychainUtil.getAccessToken())"]
        }
    }
}
