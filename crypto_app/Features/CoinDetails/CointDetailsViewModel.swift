//
//  CointDetailsViewModel.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 08.11.2022.
//

import Foundation

class CointDetailsViewModel {
    
    private let coinInfo: CoinInfo
    
    required init(coinInfo: CoinInfo) {
        self.coinInfo = coinInfo
    }
}
