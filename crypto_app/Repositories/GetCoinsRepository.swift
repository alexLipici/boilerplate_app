//
//  GetCoinsRepository.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 08.11.2022.
//

import Foundation

class GetCoinsRepository: RemoteRepository<GetCoinsResponse> {
    
    required init() {
        let endpoint = RemoteRepositoryDataLoaderRequestEndpoint(
            endpoint: Paths.GET_ASSETS,
            httpMethod: .get
        )
        let dataLoader = CommonRepositoryDataLoader(requestEndpoint: endpoint)
        
        super.init(request: dataLoader)
    }
}
