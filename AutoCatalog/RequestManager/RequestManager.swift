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
    
    public func fetchCars(page: Int) async throws -> [CarInfo] {
        let url = URL(string: "\(baseUrl)/cars/list?page=\(page)&limit=10")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decodeData([CarInfo].self, from: data)
    }
    
    public func fetchPosts(with carID: Int, page: Int) async throws -> [PostData.Post] {
        let url = URL(string: "\(baseUrl)/car/\(carID)/posts?page=\(page)&limit=10")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let postData = try JSONDecoder().decode(PostData.self, from: data)
        return postData.posts
    }

    public func fetchCarDetailData<T: Decodable>(for type: T.Type, with carID: Int) async throws -> T {
        let url = URL(string: "\(baseUrl)/car/\(carID)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decodeData(T.self, from: data)
    }
    
    private func decodeData<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
