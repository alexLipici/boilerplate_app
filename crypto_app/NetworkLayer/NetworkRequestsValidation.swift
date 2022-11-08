//
//  NetworkRequestsValidation.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import Foundation
import Alamofire

extension DataRequest {
    
    public func validateStatusCode(handleNetworkError: Bool = true) -> Self {
        
        return validate { (urlRequest, urlResponse, data) in
                        
            if 200..<300 ~= urlResponse.statusCode {
                return .success(())
                
            } else if handleNetworkError {
                
                if urlResponse.statusCode == 403 {
                    
                    return .failure(AFError.sessionInvalidated(error: RequestValidationError.sessionExpired(nil)))
                    
                } else if 500..<600 ~= urlResponse.statusCode {
                    
                    return .failure(AFError.sessionInvalidated(error: RequestValidationError.serverDown))
                    
                }  else {
                    
                    let reason: AFError.ResponseValidationFailureReason = .unacceptableStatusCode(code: urlResponse.statusCode)
                    let parsedError = AFError.responseValidationFailed(reason: reason)
                    
                    return .failure(AFError.sessionInvalidated(error: RequestValidationError.retryShouldNotBeMade(parsedError)))
                }
                
            } else {
                
                return .failure(AFError.sessionInvalidated(error: RequestValidationError.retryShouldNotBeMade(nil)))
            }
        }
    }
}

enum RequestValidationError: Error {
    case serverDown
    case sessionExpired(AFError?)
    case retryShouldNotBeMade(AFError?)
}
