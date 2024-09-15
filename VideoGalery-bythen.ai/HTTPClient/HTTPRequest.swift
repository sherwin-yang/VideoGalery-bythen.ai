//
//  HTTPRequest.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/12/24.
//

import Foundation

enum HTTPRequestError: Error, Equatable {
    case invalidURL
    case failedToFetch
    case encodingFailed
}

struct HTTPRequest {
    static private let urlSession = URLSession.shared
    
    static func makeRequest(urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard isRequestSuccess(response: response)
        else { throw URLError(.badServerResponse) }
        
        return data
    }
    
    static private func isRequestSuccess(response: URLResponse) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse else { return false }
        return (200..<300).contains(httpResponse.statusCode)
    }

}
