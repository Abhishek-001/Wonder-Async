//
//  WebService.swift
//  Pinterest-SoulVana
//
//  Created by Abhishek.Rathi on 22/04/19.
//  Copyright © 2019 Abhishek.Rathi. All rights reserved.
//

import Foundation


//--------------------------------------------------------------
// The HTTPMethod enumeration lists
//--------------------------------------------------------------

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
}

//--------------------------------------------------------------
// Singleton Pattern Used for WebService
//--------------------------------------------------------------

public class WebService: NSObject, URLSessionDelegate {
    
    public static let sharedInstance = WebService()
    lazy var activeRequests: [URL: URLSession] = [:]

    // Completion Handler block that gives Data & Error object after finishing api call.
    
    public func callRestApi(urlString : String, httpMethod: HTTPMethod,  withCompletion completion: @escaping (Data?, URLResponse?, Error?) -> Void ){
        
        // Checks for Internet availablility & returns Error if device not connected to internet.
        if !InternetConnectivityManager.sharedInstance.connectedToNetwork() {
            let err = NSError.init(domain: "", code: -1009 , userInfo:[ NSLocalizedDescriptionKey: "No Internet Connection"])
            completion(nil, nil, err)
            return
        }
        
        let session = URLSession.init(configuration: .default)
        guard let url = URL(string: urlString) else { return }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        session.dataTask(with: urlRequest ) { (data, response, error) in
            
            // Removes completed requests from the dictionary
            self.activeRequests.removeValue(forKey: url)
            print("Count Active - \(self.activeRequests.count)")
            
            if let _ = error {
                completion(nil, response ,error)
                return
            }

            guard let data = data else {
                completion(nil, nil, NSError(domain: "", code: 1, userInfo: [ NSLocalizedDescriptionKey:"Couldn't load Data"]))
                return
            }
        
            let cacheThread = DispatchQueue.init(label: "saveCache")
            cacheThread.async {
                CacheManager.shared.saveInCache(urlString: urlString , data: data, response: response!)
            }
            
            completion(data, response ,error)
        
        }.resume()
        
        activeRequests[url] = session

    }
    
//---------------------------------------------------------------------------------------
// Cancels any request using url string
//---------------------------------------------------------------------------------------
    
   public func cancelTask(urlString: String ){
        guard let url = URL(string: urlString) else { return }
        if let session = activeRequests[url] {
            session.invalidateAndCancel()
            print("\(urlString) - Session Cancelled")
        }
    }

    
}

