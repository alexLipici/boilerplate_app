//
//  NetworkManager.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static var shared: NetworkManager = {
        let networkManager = NetworkManager()
        return networkManager
    }()
    
    private var session: Session
    private let networkInterceptor: RequestInterceptor
    
    private var sessionRenewed: Bool = false
    
    private init() {
        networkInterceptor = NetworkInterceptor()
        session = EncryptedSession(interceptor: networkInterceptor)
    }
    
    func cancelRequests(paths: String...) {
        
        func shouldCancelRequest(url: String?) -> Bool {
            
            guard url != nil else { return false }
            
            for path in paths {
                if (url!.contains(path)) {
                    return true
                }
            }
            
            return false
        }
        
        session.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            
            dataTasks.forEach {
                
                if shouldCancelRequest(url: $0.originalRequest?.url?.absoluteString) {
                    $0.cancel()
                }
            }
            
            uploadTasks.forEach {
                if shouldCancelRequest(url: $0.originalRequest?.url?.absoluteString) {
                    $0.cancel()
                }
            }
            
            downloadTasks.forEach {
                if shouldCancelRequest(url: $0.originalRequest?.url?.absoluteString) {
                    $0.cancel()
                }
            }
        }
    }
    
    @discardableResult
    func newBaseCall<T>(
        url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        customHeaders: HTTPHeaders? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) -> DataRequest where T: Decodable {
                        
        print("Request to \(url)")
        
        return session
            .request(url,
                     method: method,
                     parameters: parameters,
                     encoding: encoding,
                     headers: customHeaders)
            .validateStatusCode(handleNetworkError: true)
            .responseDecodable { (response: DataResponse<T, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    print(error)
                    guard !error.isServerTrustEvaluationError else {
                        return completion(.failure(.sslError))
                    }
                    
                    guard !error.isRequestRetryError else {
                        
                        // error thrown by retry block
                        if let underlyingError = error.underlyingError as? RetryRequestError {
                            
                            switch underlyingError {
                            case .retryLimitReached, .cannotReachServer, .sessionCouldNotBeRenewed:
                                return completion(.failure(.cannotReachServer))
                            case .retryBlocked(let passedError):
                                return completion(.failure(self._parseAFError(passedError)))
                            case .sslErrorCannotRenewCertificates:
                                return completion(.failure(.sslError))
                            case .sslErrorShouldRenewSession:
                                
                                if !self.sessionRenewed {
                                    self.renewSession()
                                }
                                
                                self.newBaseCall(
                                    url: url,
                                    method: method,
                                    parameters: parameters,
                                    encoding: encoding,
                                    customHeaders: customHeaders,
                                    completion: completion)
                                return
                                
                            case .noInternet:
                                return completion(.failure(.noInternet))
                            case .requestCanceled:
                                return completion(.failure(.canceled))
                            }
                            
                        } else {
                            
                            // Handle request cancel error
                            switch error {
                            case .requestRetryFailed(retryError: let retryError, originalError: _):
                                if let retryErrorParsed = retryError.asAFError,
                                   retryErrorParsed.isExplicitlyCancelledError {
                                    return
                                } else {
                                    fallthrough
                                }
                            default:
                                return completion(.failure(.unknown))
                            }
                        }
                    }
                    
                    // If the retry block does not fire any error, check what error was received from the request
                    return completion(.failure(self._parseAFError(error.asAFError)))
                }
            }
    }
    
    private func renewSession() {
        sessionRenewed = true
        session.session.invalidateAndCancel()
        session = EncryptedSession(interceptor: networkInterceptor)
    }
    
    private func _parseAFError(_ error: AFError?) -> NetworkError {
        
        guard
            let error = error,
            error.isResponseValidationError
        else {
            return .unknown
        }
        
        guard
            let underlyingError = error.underlyingError,
            let urlError = underlyingError as? URLError
        else {
            return .unknown
        }
        
        switch urlError.code {
        case .notConnectedToInternet:
            return .noInternet
        case .cancelled:
            return .canceled
        case .appTransportSecurityRequiresSecureConnection,
                .secureConnectionFailed:
            return .sslError
        default:
            return .customMessage(urlError.localizedDescription)
        }
    }

}

struct CustomGetEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try URLEncoding().encode(urlRequest, with: parameters)
        request.url = URL(string: request.url!.absoluteString.replacingOccurrences(of: "%5B%5D=", with: "="))
        return request
    }
}
