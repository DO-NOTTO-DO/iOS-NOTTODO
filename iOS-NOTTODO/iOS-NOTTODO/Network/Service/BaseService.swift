//
//  BaseAPI.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/10/24.
//

import Foundation
import Combine

import Alamofire
import Moya

final class BaseService<Target: TargetType> {
    
    typealias API = Target
    
    // MARK: - Properties
    
    var cancelBag = Set<AnyCancellable>()
    
    lazy var provider = self.defaultProvider
    
    private lazy var defaultProvider: MoyaProvider<API> = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let interceptor = AuthInterceptor.shared
        let session = Session(configuration: configuration, interceptor: interceptor)
        let provider = MoyaProvider<API>(
            session: session,
            plugins: [MoyaLoggingPlugin()]
        )
        return provider
    }()
    
    // MARK: - Initializers
    
    public init() {}
}

// MARK: - Providers

extension BaseService {
    var `default`: BaseService {
        self.provider = self.defaultProvider
        return self
    }
}

// MARK: - MakeRequests

extension BaseService {
    
    func requestWithCombine<T: Decodable>(_ target: API) -> AnyPublisher<T, Error> {
        return Future { promise in
            self.provider.request(target) { response in
                switch response {
                case .success(let value):
                    do {
                        let decoder = JSONDecoder()
                        let body = try decoder.decode(T.self, from: value.data)
                        promise(.success(body))
                    } catch let error {
                        promise(.failure(error))
                    }
                case .failure(let error):
                    if case MoyaError.underlying(let error, _) = error,
                       case AFError.requestRetryFailed(let retryError, _) = error,
                       let retryError = retryError as? APIError,
                       retryError == APIError.tokenReissuanceFailed {
                        promise(.failure(retryError))
                    } else {
                        promise(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // status codea만 사용하는 경우
    func requestWithCombineNoResult(_ target: API) -> AnyPublisher<Int, Error> {
        return Future { promise in
            self.provider.request(target) { response in
                switch response {
                case .success(let value):
                    promise(.success(value.statusCode))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
