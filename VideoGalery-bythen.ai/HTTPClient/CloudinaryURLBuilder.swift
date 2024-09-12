//
//  CloudinaryURLBuilder.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/12/24.
//

import Foundation

struct CloudinaryURLBuilder {
    private let path: String
    
    init(path: String) {
        self.path = path
    }
    
    func createURL() -> URL? {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.cloudinary.com"
        component.path = "/v1_1/dk3lhojel/\(path)"
        return component.url
    }
}
