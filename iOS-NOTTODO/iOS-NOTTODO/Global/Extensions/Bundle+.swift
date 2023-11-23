//
//  Bundle+.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/07/04.
//
//
import Foundation

extension Bundle {
    
    var amplitudeAPIKey: String {
        guard let filePath = Bundle.main.path(forResource: "API_KEY", ofType: "plist") else {
            fatalError("Couldn't find file 'AMPLITUDE_API_KEY.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let value = plist?.object(forKey: "AMPLITUDE_API_KEY") as? String else {
            fatalError("Couldn't find key 'AMPLITUDE_API_KEY' in 'API_KEY.plist'.")
        }
        return value
    }
    
    var kakaoAPIKey: String {
        guard let filePath = Bundle.main.path(forResource: "API_KEY", ofType: "plist") else {
            fatalError("Couldn't find file 'AMPLITUDE_API_KEY.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let value = plist?.object(forKey: "KAKAO_API_KEY") as? String else {
            fatalError("Couldn't find key 'KAKAO_API_KEY' in 'API_KEY.plist'.")
        }
        return value
    }
    
    var baseURL: String {
        guard let filePath = Bundle.main.path(forResource: "API_KEY", ofType: "plist") else {
            fatalError("Couldn't find file 'AMPLITUDE_API_KEY.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let value = plist?.object(forKey: "BASE_URL") as? String else {
            fatalError("Couldn't find key 'BASE_URL' in 'API_KEY.plist'.")
        }
        return value
    }
    
    var appleId: String {
        guard let filePath = Bundle.main.path(forResource: "API_KEY", ofType: "plist") else {
            fatalError("Could't find file 'API_KEY.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let value = plist?.object(forKey: "APPLE_ID") as? String else {
            fatalError("Couldn't find key 'APPLE_ID' in 'API_KEY.plist'.")
        }
        return value
    }
}
