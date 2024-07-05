//
//  URLScheme.swift
//  MindPause
//
//  Created by Vishal Manhas on 23/04/24.
//

import Foundation



enum URLScheme {
    case http
    case https
    
    var stringValue: String {
        switch self {
        case .http:
            return "http"
        case .https:
            return "https"
        }
    }
}

enum URLAsset {
    
    static let scheme: URLScheme = .https
    static let baseURL = "newsapi.org"
    
    static func baseURLString() -> String {
        return "\(scheme.stringValue)://\(baseURL)"
    }
}



enum APIServices: String {
    case  newsURl = "/v2/top-headlines?country=us&category=business&apiKey=81ffd09752e44e5084140394e65fdb96"
}



