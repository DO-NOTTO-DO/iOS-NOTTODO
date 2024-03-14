//
//  AuthAPI.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/21.
//

import Foundation

import Moya

typealias AuthData = GeneralResponse<AuthResponseDTO>
typealias EmptyData = GeneralResponse<VoidType>

protocol AuthServiceType {
    func postKakaoAuth(social: LoginType, request: AuthRequest, completion: @escaping (AuthData?) -> Void)
    func postAppleAuth(social: LoginType, request: AuthRequest, completion: @escaping (AuthData?) -> Void)
    func deleteAuth(completion: @escaping (EmptyData?) -> Void)
    func withdrawalAuth(completion: @escaping (EmptyData?) -> Void)
}

final class AuthService: AuthServiceType {
    
    static let shared: AuthService = AuthService()
    
    private let authProvider = MoyaProvider<AuthAPI>(session: Session(interceptor: AuthInterceptor.shared), plugins: [MoyaLoggingPlugin()])
    
    private init() { }
    
    // MARK: - POST
    
    func postKakaoAuth(social: LoginType, request: AuthRequest, completion: @escaping (AuthData?) -> Void) {
        authProvider.request(.kakaoAuth(social: social, request: request)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(AuthData?.self)
                    completion(response)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func postAppleAuth(social: LoginType, request: AuthRequest, completion: @escaping (AuthData?) -> Void) {
        authProvider.request(.appleAuth(social: social, request: request)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(AuthData?.self)
                    completion(response)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    // MARK: - Delete
    
    func deleteAuth(completion: @escaping (EmptyData?) -> Void) {
        authProvider.request(.logout) { _ in
            completion(nil)
        }
    }
    
    // MARK: - Withdrawal
    
    func withdrawalAuth(completion: @escaping (EmptyData?) -> Void) {
        authProvider.request(.withdrawal) { _ in
            completion(nil)
        }
    }
}
