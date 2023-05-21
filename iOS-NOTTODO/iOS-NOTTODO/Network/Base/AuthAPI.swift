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
    
    func postAuth(newMission: AuthRequestDTO, completion: @escaping (GeneralResponse<AuthResponse>?) -> Void) {
        authProvider.request(.auth(newAuth)) { result in
            switch result {
            case .success(let response):
                do {
                    guard let authData = try response.map(GeneralResponse<AuthResponse>?.self) else { return }
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
}

