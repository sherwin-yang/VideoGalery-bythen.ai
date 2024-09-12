//
//  APIURLRequest.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/12/24.
//

import Foundation

enum HTTPRequestMethod: String {
    case GET, POST, DELETE
}

protocol URLRequestBuilder {
    func setMethod(_ method: HTTPRequestMethod) -> Self
    func setHeader(_ header: [String: String]) -> Self
    func setBody(_ body: [String: Any]) -> Self
    func build() -> URLRequest
}

struct APIURLRequest: URLRequestBuilder {
    private let mutableUrlRequest: NSMutableURLRequest
    
    init(url: URL) {
        mutableUrlRequest = NSMutableURLRequest(url: url)
    }
    
    func setMethod(_ method: HTTPRequestMethod) -> Self {
        mutableUrlRequest.httpMethod = method.rawValue
        return self
    }
    
    func setHeader(_ header: [String: String]) -> Self {
        mutableUrlRequest.allHTTPHeaderFields = header
        return self
    }
    
    func setBody(_ body: [String: Any]) -> Self {
        guard let paramData = try? JSONSerialization.data(withJSONObject: body)
        else { return self }
        
        mutableUrlRequest.httpBody = paramData
        return self
    }
    
    func build() -> URLRequest { mutableUrlRequest as URLRequest }
}
