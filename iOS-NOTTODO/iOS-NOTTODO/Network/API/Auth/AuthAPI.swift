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
    
    private let authProvider = MoyaProvider<AuthService>(plugins: [MoyaLoggingPlugin()])
    
    private init() { }
    
    // MARK: - POST
    
    func postAuth(social: String, socialToken: String, fcmToken: String, name: String, email: String, completion: @escaping (GeneralResponse<AuthResponseDTO>?) -> Void) {
        authProvider.request(.auth(social: social, socialToken: socialToken, fcmToken: fcmToken, name: name, email: email)) { result in
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
        authProvider.request(.logout) { result in
            switch result {
            case .success(_):
              completion(nil)
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    func withdrawalAuth(completion: @escaping (GeneralResponse<VoidType>?) -> Void) {
        authProvider.request(.withdrawal) { result in
            switch result {
            case .success(_):
              completion(nil)
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
}
