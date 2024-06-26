//
//  WidgetService.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 5/10/24.
//

import Foundation
import SwiftUI

typealias QuoteData = GeneralResponse<QuoteResponseDTO>
typealias DailyMissionData = GeneralArrayResponse<DailyMissionResponseDTO>
typealias UpdateMissionStatus = GeneralResponse<DailyMissionResponseDTO>

struct WidgetService {
    @AppStorage(DefaultKeys.accessToken, store: UserDefaults.shared) var accessToken: String = ""
    
    static let shared = WidgetService()
    private init() {}
    
    let session = URLSession(configuration: URLSessionConfiguration.default, delegate: URLSessionLoggingDelegate(), delegateQueue: nil)
    
    func fetchWiseSaying() async throws -> QuoteResponseDTO {
        do {
            return try await getWiseSaying(
                from: generateURL(constant: URLConstant.quote))
        } catch {
            switch error {
            case NetworkError.networkError:
                print("네트워크 에러가 발생")
            case NetworkError.invalidResponse:
                print("유효하지 않은 응답")
            case NetworkError.dataParsingError:
                print("데이터 파싱 실패")
            default:
                print("알 수 없는 에러 발생")
            }
            throw error
        }
    }
    
    func fetchDailyMissoin(date: String) async throws -> [DailyMissionResponseDTO] {
        do {
            return try await getDailyMission(
                from: generateURL(constant: URLConstant.recommend + URLConstant.dailyMission, parameter: date))
        } catch {
            switch error {
            case NetworkError.networkError:
                print("네트워크 에러가 발생")
            case NetworkError.invalidResponse:
                print("유효하지 않은 응답")
            case NetworkError.dataParsingError:
                print("데이터 파싱 실패")
            default:
                print("알 수 없는 에러 발생")
            }
            throw error
        }
    }
    
    func updateMission(id: Int, status: String) async throws {
        do {
            try await patchUpdateMission(
                from: generateURL(constant: URLConstant.recommend, parameter: "\(id)" + "/check"),
                id: id,
                requestData: status)
            
            let dailyMission = try await fetchDailyMissoin(date: Formatter.dateFormatterString(format: nil, date: Date()))
            UserDefaults.shared?.setSharedCustomArray(dailyMission, forKey: "dailyMission")
        } catch {
            switch error {
            case NetworkError.networkError:
                print("네트워크 에러가 발생")
            case NetworkError.invalidResponse:
                print("유효하지 않은 응답")
            case NetworkError.dataParsingError:
                print("데이터 파싱 실패")
            case NetworkError.encodingFailed:
                print("데이터 인코딩 실패")
            case NetworkError.invalidRequestParameters:
                print("유효하지 않은 파라미터")
            default:
                print("알 수 없는 에러 발생")
            }
            throw error
        }
    }
    
    private func getWiseSaying(from url: URL) async throws -> QuoteResponseDTO {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.networkError
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let result = try JSONDecoder().decode(QuoteData.self, from: data)
            guard let responseData = result.data else {
                throw NetworkError.dataParsingError
            }
            return responseData
        } catch {
            throw NetworkError.dataParsingError
        }
    }
    
    private func getDailyMission(from url: URL) async throws -> [DailyMissionResponseDTO] {
        var request = URLRequest(url: url)
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken,
                         forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.networkError
        }
        
        print("Response Status Code: \(httpResponse.statusCode)")
        print("Response Headers: \(httpResponse.allHeaderFields)")
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let result = try JSONDecoder().decode(DailyMissionData.self, from: data)
            guard let responseData = result.data else {
                throw NetworkError.dataParsingError
            }
            return responseData
        } catch {
            throw NetworkError.dataParsingError
        }
    }
    
    private func patchUpdateMission(from url: URL, id: Int, requestData: String) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        
        do {
            let body = ["completionStatus": requestData]
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
            if let bodyData = request.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
                print("Request Body: \(bodyString)")
            } else {
                print("Request Body is empty or cannot be converted to String.")
            }
        } catch {
            print("Encoding Failed: \(error)")
            throw NetworkError.encodingFailed
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response received")
                throw NetworkError.networkError
            }
            
            print("Response Status Code: \(httpResponse.statusCode)")
            print("Response Headers: \(httpResponse.allHeaderFields)")
            
            if (200..<300).contains(httpResponse.statusCode) {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                } else {
                    print("Response data is not a valid string.")
                }
                do {
                    let result = try JSONDecoder().decode(UpdateMissionStatus.self, from: data)
                    guard let responseData = result.data else {
                        print("Data Parsing Error: \(String(data: data, encoding: .utf8) ?? "No data")")
                        throw NetworkError.dataParsingError
                    }
                    print("Response Data: \(responseData)")
                } catch {
                    print("Data Parsing Error: \(error)")
                    throw NetworkError.dataParsingError
                }
            } else {
                print("Invalid response status code: \(httpResponse.statusCode)")
                throw NetworkError.invalidResponse
            }
        } catch {
            print("Network Request Failed: \(error)")
            throw NetworkError.networkError
        }
    }
    
    private func generateURL(constant: String, parameter: String = "") -> URL {
        let baseURL = Bundle.main.baseURL
        let url = baseURL + constant + "/\(parameter)"
        print(url)
        return URL(string: url)!
    }
}
