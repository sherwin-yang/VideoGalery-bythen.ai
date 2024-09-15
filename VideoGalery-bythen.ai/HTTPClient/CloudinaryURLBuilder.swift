//
//  CloudinaryURLBuilder.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/12/24.
//

import Foundation

enum CloudinaryURLBuilderError: Error {
    case failedBuilding
}

struct CloudinaryURLBuilder {
    private let path: String
    private let param: [String: String]
    
    init(path: String, param: [String: String] = [:]) {
        self.path = path
        self.param = param
    }
    
    func build() throws -> URL {
        guard let url = createURL()
        else { throw CloudinaryURLBuilderError.failedBuilding }
        return url
    }
    
    private func createURL() -> URL? {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.cloudinary.com"
        component.path = "/v1_1/dk3lhojel/\(path)"
        if !param.isEmpty {
            component.queryItems = param.map { .init(name: $0.key, value: $0.value) }
        }
        return component.url
    }
}
