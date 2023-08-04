//
//  CarInfoDetail.swift
//  AutoCatalog
//
//  Created by Александра Кострова on 03.08.2023.
//

import Foundation

struct CarInfoDetail: Codable {
    
    struct Car: Codable {
        let id: Int
        let brandName: String
        let modelName: String
        let year: Int
        let transmissionName: String
        let images: [CarImages]
        let engine: String
        
        enum CodingKeys: String, CodingKey {
            case id, year, images, engine
            case brandName = "brand_name"
            case modelName = "model_name"
            case transmissionName = "transmission_name"
        }
        
        struct CarImages: Codable {
            let url: String
        }
    }
    
        struct User: Codable {
            let id: Int
            let username: String
            let avatar: Avatar
        }

        struct Avatar: Codable {
            let path: String
            let url: String
        }

    let car: Car
    let user: User
}

