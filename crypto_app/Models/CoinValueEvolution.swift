//
//  CoinValueEvolution.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 08.11.2022.
//

import Foundation

struct CoinValueEvolution: Decodable {
    var priceUsd: String
    var time: Date
    
    enum CodingKeys: CodingKey {
        case priceUsd
        case time
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CoinValueEvolution.CodingKeys> = try decoder.container(keyedBy: CoinValueEvolution.CodingKeys.self)
        
        self.priceUsd = try container.decode(String.self, forKey: .priceUsd)
        let _time = try container.decode(Double.self, forKey: .time)
        time = Date(timeIntervalSince1970: _time)
    }
}
