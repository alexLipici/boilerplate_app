//
//  NetworkInterceptor.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import Foundation
import Alamofire

enum RetryRequestError: Error {
    case cannotReachServer
    case sessionCouldNotBeRenewed
    case retryLimitReached
    case retryBlocked(AFError?)
    case noInternet
    case requestCanceled
    case sslErrorShouldRenewSession
    case sslErrorCannotRenewCertificates
}

class NetworkInterceptor: RequestInterceptor {
    
    private typealias RequestCompletion = (RetryResult) -> Void
    
    private let retryLimit: Int = 2
    private var isRefreshingSession: Bool = false
    private var isRefreshingSSLCertificates: Bool = false
    private var locker = NSRecursiveLock()
    
    private var failedCompletions: [RequestCompletion] = []
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        
        locker.lock(); defer { locker.unlock() }
        
        guard request.retryCount < retryLimit else {
            return completion(.doNotRetryWithError(RetryRequestError.retryLimitReached))
        }
        
        func _retryWithDelay() {
            
            let delay = TimeInterval(request.retryCount * 2)
            return completion(.retryWithDelay(delay))
        }
        
        guard
            let afError = error.asAFError
        else {
            
            return completion(.doNotRetryWithError(error))
        }
        
        // AF calls the retrier a second time with a RetryError
        // Prevent double calls by exiting
        if afError.isRequestRetryError {
            
            // Handle request cancel error
            switch afError {
                case .requestRetryFailed(retryError: let retryError, originalError: _):
                    if let retryErrorParsed = retryError.asAFError,
                       retryErrorParsed.isExplicitlyCancelledError {
                        return completion(.doNotRetryWithError(RetryRequestError.requestCanceled))
                    } else {
                        fallthrough
                    }
                default:
                    return completion(.doNotRetry)
            }
        }
        
        // Check for ssl error and lock the retry if there is one
        if afError.isServerTrustEvaluationError {
            
            failedCompletions.append(completion)
            
            refreshSSLCertificates { [weak self] (fetchingSucceded) in
                
                self?.locker.lock(); defer { self?.locker.unlock() }
                
                if fetchingSucceded {
                    self?.failedCompletions.forEach({ $0(.doNotRetryWithError(RetryRequestError.sslErrorShouldRenewSession))})
                } else {
                    self?.failedCompletions.forEach({ $0(.doNotRetryWithError(RetryRequestError.sslErrorCannotRenewCertificates))})
                }
                
                self?.failedCompletions.removeAll()
            }
            return
        }
        
        // Check if validation throw an error that a retry shouldn't be made. This one is fired by NetworkGenericSiteValidation. This one is fired when the request respond with a status code
        if afError.isSessionInvalidatedError,
           let validationError = afError.underlyingError as? RequestValidationError {
            
            switch validationError {
                
                case .serverDown:
                    
                    return completion(.doNotRetryWithError(RetryRequestError.cannotReachServer))
                    
                case .retryShouldNotBeMade(let passedErrorFromValidation):
    
                    return completion(.doNotRetryWithError(RetryRequestError.retryBlocked(passedErrorFromValidation)))
                    
                case .sessionExpired:
                                        
                    failedCompletions.append(completion)
                    
                    refreshSession { [weak self] (success) in
                        
                        self?.locker.lock(); defer { self?.locker.unlock() }
                        
                        if success {
                            self?.failedCompletions.forEach({ $0(.retryWithDelay(TimeInterval(1)))})
                        } else {
                            self?.failedCompletions.forEach({ $0(.doNotRetryWithError(RetryRequestError.sessionCouldNotBeRenewed))})
                        }
                        
                        self?.failedCompletions.removeAll()
                    }
                    
                    return
            }
        }
        
        // Check if there is a response status code that requires retry
        if afError.isResponseValidationError,
           afError.responseCode != nil {
            return _retryWithDelay()
        }
        
        guard
            let underlyingError = afError.underlyingError,
            let urlError = underlyingError as? URLError
        else {
            return completion(.doNotRetryWithError(error))
        }
        
        // Check for internet connection error and lock the retry if the is one
        if hasNoInternetConnection(urlError.code) {
            
            return completion(.doNotRetryWithError(RetryRequestError.noInternet))
        }
        
        // Check if there is an connection error and retry the request
        if hasConnectionError(urlError.code) {
            return completion(.doNotRetryWithError(RetryRequestError.cannotReachServer))
        }
        
        if isCanceled(urlError.code) {
            
            return completion(.doNotRetryWithError(RetryRequestError.requestCanceled))
        }
        
        return completion(.doNotRetryWithError(error))
    }
    
    private func hasNoInternetConnection(_ code: URLError.Code) -> Bool {
        return code == .notConnectedToInternet
    }
    
    private func hasConnectionError(_ code: URLError.Code) -> Bool {
        switch code {
            case .cannotFindHost:
                return true
            case .cannotConnectToHost:
                return true
            case .secureConnectionFailed:
                return true
            case .serverCertificateHasBadDate:
                return true
            case .serverCertificateUntrusted:
                return true
            case .serverCertificateHasUnknownRoot:
                return true
            case .serverCertificateNotYetValid:
                return true
            case .clientCertificateRejected:
                return true
            case .clientCertificateRequired:
                return true
            case .cannotLoadFromNetwork:
                return true
            case .networkConnectionLost:
                return true
            case .timedOut:
                return true
            default:
                return false
        }
    }
    
    private func isCanceled(_ code: URLError.Code) -> Bool {
        switch code {
            case .cancelled: return true
            default: return false
        }
    }
    
    private func refreshSession(completion: @escaping (_ success: Bool) -> Void) {
        
        if !isRefreshingSession {
            
            isRefreshingSession = true
            
            #warning("put refreshing logic here")
            completion(true)
            isRefreshingSession = false
        }
    }
    
    private func refreshSSLCertificates(completion: @escaping (_ success: Bool) -> Void) {
        
        if !isRefreshingSSLCertificates {
            
            isRefreshingSSLCertificates = true
            
            #warning("put refreshing local certificates logic here")
            completion(true)
            isRefreshingSSLCertificates = false
        }
    }
}
