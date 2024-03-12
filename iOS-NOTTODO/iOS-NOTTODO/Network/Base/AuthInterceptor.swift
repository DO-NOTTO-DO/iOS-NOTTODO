//
//  AuthInterceptor.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 11/23/23.
//

import Foundation

import Alamofire

enum NotificationCenterKey {
    static let refreshTokenHasExpired = Notification.Name("refreshTokenHasExpired")
}

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
            // token 만료 시 -> auth 화면 전환
            NotificationCenter.default.post(name: NotificationCenterKey.refreshTokenHasExpired, object: nil)
        }
        completion(.doNotRetry)
    }
}
