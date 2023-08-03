//
//  Post.swift
//  AutoCatalog
//
//  Created by Александра Кострова on 03.08.2023.
//

import Foundation

struct PostData: Codable {
    struct Post: Codable {
        let text: String
        let likeCount: Int
        let createdAt: String
        let commentCount: Int
        let image: String
        
        enum CodingKeys: String, CodingKey {
            case text
            case image = "img"
            case likeCount = "like_count"
            case createdAt = "created_at"
            case commentCount = "comment_count"
        }
    }
    
    let posts: [Post]
}

