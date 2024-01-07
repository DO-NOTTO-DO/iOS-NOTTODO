//
//  AuthInterceptor.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 11/23/23.
//

import Foundation

import Alamofire

final class AuthInterceptor: RequestInterceptor {
    
    static let shared = AuthInterceptor()
    
    private init() {}
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401
        else {
            completion(.doNotRetry)
            return
        }
        
        DispatchQueue.main.async {
            SceneDelegate.shared?.changeRootViewControllerTo(AuthViewController())
        }
    }
}
