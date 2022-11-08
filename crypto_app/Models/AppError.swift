//
//  AppError.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import Foundation

enum AppError: Error {
    case customMessage(String)
    case unknown
}

enum NetworkError: Error {
    case customMessage(String)
    case cannotReachServer
    case noInternet
    case sslError
    case canceled
    case decodingError
    case unknown
    
    func toAppError() -> AppError {
        switch self {
        case .customMessage(let string):
            return .customMessage(string)
        case .noInternet:
            return .customMessage("No internet connection")
        case .sslError, .canceled, .unknown:
            return .unknown
        case .cannotReachServer:
            return .customMessage("Cannot connect to services")
        case .decodingError:
            return .customMessage("Cannot parse response")
        }
    }
}
