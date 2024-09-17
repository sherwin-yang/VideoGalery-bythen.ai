//
//  GetResponse.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/14/24.
//

import Foundation

struct ResourcesResponse<T: Decodable>: Decodable {
    let resources: T
}

struct GetResponse<T> {
    private let getData: () async throws -> Data
    private let decoder: (Data) throws -> T
    
    init(
        getData: @escaping () async throws -> Data,
        decoder: @escaping (Data) throws -> T
    ) {
        self.getData = getData
        self.decoder = decoder
    }
    
    func fetch() async throws -> T {
        let data = try await getData()
        return try decoder(data)
    }
}
