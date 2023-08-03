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
        let engine: String
        
        enum CodingKeys: String, CodingKey {
            case id, year, engine
            case brandName = "brand_name"
            case modelName = "model_name"
            case transmissionName = "transmission_name"
        }
    }
    
        struct User: Codable {
            let id: Int
            let username: String
            let avatar: Avatar
        }

        struct Avatar: Codable {
            let path: String
            let url: URL
        }

    let car: Car
    let user: User
}

