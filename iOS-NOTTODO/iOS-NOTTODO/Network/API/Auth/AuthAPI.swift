//
//  AuthAPI.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/21.
//

import Foundation

import Moya

final class AuthAPI {
    
    static let shared: AuthAPI = AuthAPI()
    
    private let authProvider = MoyaProvider<AuthService>(session: Session(interceptor: AuthInterceptor.shared), plugins: [MoyaLoggingPlugin()])
    
    private init() { }
    
    // MARK: - POST
    
    func postKakaoAuth(social: String, socialToken: String, fcmToken: String, completion: @escaping (GeneralResponse<AuthResponseDTO>?) -> Void) {
        authProvider.request(.kakaoAuth(social: social, socialToken: socialToken, fcmToken: fcmToken)) { result in
            switch result {
            case .success(let response):
                do {
                    guard let authData = try response.map(GeneralResponse<AuthResponseDTO>?.self) else { return }
                    completion(authData)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func postAppleAuth(social: String, socialToken: String, fcmToken: String, name: String, completion: @escaping (GeneralResponse<AuthResponseDTO>?) -> Void) {
        authProvider.request(.appleAuth(social: social, socialToken: socialToken, fcmToken: fcmToken, name: name)) { result in
            switch result {
            case .success(let response):
                do {
                    guard let authData = try response.map(GeneralResponse<AuthResponseDTO>?.self) else { return }
                    completion(authData)
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
    
    func deleteAuth(completion: @escaping (GeneralResponse<VoidType>?) -> Void) {
        authProvider.request(.logout) { _ in
            completion(nil)
        }
    }
    
    // MARK: - Withdrawal
    
    func withdrawalAuth(completion: @escaping (GeneralResponse<VoidType>?) -> Void) {
        authProvider.request(.withdrawal) { _ in
            completion(nil)
        }
    }
}
