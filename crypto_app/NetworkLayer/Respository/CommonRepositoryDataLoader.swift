//
//  CommonRepositoryDataLoader.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 08.11.2022.
//

import Alamofire

struct CommonRepositoryDataLoader: RemoteRepositoryDataLoaderProtocol {
    
    var requestEndpoint: RemoteRepositoryDataLoaderRequestEndpoint
    
    var encoding: ParameterEncoding = CustomGetEncoding()
    
    internal var request: Request?
    
    mutating func loadData<ResponseModel>(
        callParameters: Parameters,
        completion: @escaping (Result<ResponseModel, NetworkError>) -> Void
    ) where ResponseModel: Decodable {
        
        request = NetworkManager.shared.newBaseCall(
            url: requestEndpoint.endpoint,
            method: requestEndpoint.httpMethod,
            parameters: callParameters,
            encoding: encoding,
            completion: completion
        )
    }
}
