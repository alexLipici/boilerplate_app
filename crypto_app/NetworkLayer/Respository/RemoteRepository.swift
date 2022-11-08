//
//  RemoteRepository.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import Foundation
import Alamofire

class RemoteRepository<Item: Decodable> {
    private var request: RemoteRepositoryDataLoaderProtocol
    
    deinit {
        print("☠️ deinit called on \(NSStringFromClass(type(of: self)))")
    }
    
    init(request: RemoteRepositoryDataLoaderProtocol) {
        self.request = request
    }

    func executeRequest(parameters: Parameters, completion: @escaping (Result<Item, NetworkError>)->Void) {
        
        request.loadData(callParameters: parameters, completion: completion)
    }
    
    func cancelRequest() {
        request.cancelRequest()
    }
}
