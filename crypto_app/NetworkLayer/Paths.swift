//
//  Paths.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import Foundation

struct Paths {
    
    private struct BASE_API {
        
        private static let basePath: String =
            "https://api.coincap.io"
        private static let latestVersion: String = "v2"
        
        static var versioned: String {
            return String(format: "%@/%@/", basePath, latestVersion)
        }
        
        static var unversioned: String {
            return String(format: "%@/", basePath)
        }
    }
    
    /**
     PATHS
     */
    
    static let GET_ASSETS = "\(BASE_API.versioned)assets"
}
