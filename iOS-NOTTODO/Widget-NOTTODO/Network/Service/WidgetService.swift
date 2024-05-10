//
//  WidgetService.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 5/10/24.
//

import Foundation

typealias QuoteData = GeneralResponse<QuoteResponseDTO>

struct WidgetService {
    
    static let shared = WidgetService()
    private init() {}
    
    private let session = URLSession.shared
    
    func fetchWiseSaying() async throws -> QuoteResponseDTO {
        do {
            return try await getWiseSaying(from: generateURL())
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
    
    private func generateURL() -> URL {
        let baseURL = Bundle.main.baseURL
        let url = baseURL + URLConstant.quote
        return URL(string: url)!
    }
}
