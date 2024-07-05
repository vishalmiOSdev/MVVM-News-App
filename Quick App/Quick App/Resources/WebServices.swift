//
//  WebServices.swift
//  MindPause
//
//  Created by Vishal Manhas on 23/04/24.
//

import Foundation
import UIKit


enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

enum RequestType: String {
    case get = "GET"
    case post = "POST"
}

final class Webservice {
    
    static let shared = Webservice()
    
    
    private init() {}
    
    
    enum HTTPMethod: String {
        case post = "POST"
        case get = "GET"
    }
 
    func doRequestAsync<T: Codable>(_ url: URL?, type: HTTPMethod, header: [String: String] = [:], body: T? = nil, responseFromServer: T.Type) async throws -> T {
        
        
        guard let url = url else {
            fatalError("Wrong URL")
        }
        
        ActivityIndicatorManager.showActivityIndicator()
        
        defer {
            ActivityIndicatorManager.hideActivityIndicator()
        }
        
        print("URL:- \(url)")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpMethod = type.rawValue
        
        if let body = body {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "InvalidResponse", code: 0, userInfo: nil)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)
        }
        
      
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            
            if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []),
               
               let json = try? JSONSerialization.data(withJSONObject: jsonData, options: .fragmentsAllowed),
               
               let jsonString = String(data: json, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }
            
            return decodedData
        } catch {
            throw error
        }
    }

}

//Completion Handler Call
    
/* func doRequest<T: Codable>(_ url: URL?, type: HTTPMethod, header: [String: String] = [:], body: T? = nil, responseFromServer: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
    guard let url = url else {
        
        fatalError("Wrong URL")
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.allHTTPHeaderFields = header
    urlRequest.httpMethod = type.rawValue

    if let body = body {
        do {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
    }

    let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            let error = NSError(domain: "InvalidResponse", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let error = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)
            completion(.failure(error))
            return
        }

        guard let data = data else {
            let error = NSError(domain: "NoData", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }

        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            
            // Print the response in JSON format
            if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []),
               let json = try? JSONSerialization.data(withJSONObject: jsonData, options: .fragmentsAllowed),
               let jsonString = String(data: json, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }

            completion(.success(decodedData))
        } catch {
            completion(.failure(error))
        }
    }

    task.resume()
} */


