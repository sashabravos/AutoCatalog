//
//  RequestManager.swift
//  AutoCatalog
//
//  Created by Александра Кострова on 03.08.2023.
//

import Foundation

final class RequestManager {
    
    static let shared = RequestManager()
    private init() {}
    
    private let baseUrl = "http://am111.05.testing.place/api/v1"
    
    public func fetchCars(page: Int) async throws -> [Car] {
        let url = URL(string: "\(baseUrl)/cars/list?page=\(page)&limit=10")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decodeData(data)
    }
    
    private func decodeData<T: Codable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
