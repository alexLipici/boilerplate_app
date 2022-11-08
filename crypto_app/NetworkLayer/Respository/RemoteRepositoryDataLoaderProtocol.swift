//
//  RemoteRepositoryDataLoaderProtocol.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import Foundation
import Alamofire

struct RemoteRepositoryDataLoaderRequestEndpoint {
    let endpoint: String
    let httpMethod: HTTPMethod
    
    init(endpoint: String, httpMethod: HTTPMethod) {
        self.endpoint = endpoint
        self.httpMethod = httpMethod
    }
}

protocol RemoteRepositoryDataLoaderProtocol {        
    var requestEndpoint: RemoteRepositoryDataLoaderRequestEndpoint { set get }
    
    var request: Request? { set get }
    
    mutating func loadData<ResponseModel: Decodable>(
        callParameters: Parameters,
        completion: @escaping (Result<ResponseModel, NetworkError>) -> Void
    )
    
    func cancelRequest()
}

extension RemoteRepositoryDataLoaderProtocol {
    func cancelRequest() {
        request?.cancel()
    }
}
