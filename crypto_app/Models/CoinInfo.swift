//
//  CoinInfo.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 08.11.2022.
//

import Foundation

struct GetCoinsResponse: Decodable {
    let data: [CoinInfo]
}

struct CoinInfo: Decodable {
    let id, rank, symbol, name: String?
    let supply, maxSupply, marketCapUsd, volumeUsd24Hr: String?
    let priceUsd, changePercent24Hr, vwap24Hr: String?
}
