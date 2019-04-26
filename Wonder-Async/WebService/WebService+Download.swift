//
//  WebService+Download.swift
//  Pinterest-SoulVana
//
//  Created by Abhishek.Rathi on 24/04/19.
//  Copyright © 2019 Abhishek.Rathi. All rights reserved.
//

import Foundation

extension WebService {
    
    // This APIs should also be used if you need to download data while your app is in the background.
    func downloadFile(urlString : String, httpMethod: String, withCompletion completion: @escaping (URL?, Error?) -> Void ){
        
        // Checks for Internet availablility & returns Error if device not connected to internet.
        if !InternetConnectivityManager.sharedInstance.connectedToNetwork() {
            let err = NSError.init(domain: "", code: -1009 , userInfo:[ NSLocalizedDescriptionKey: "No Internet Connection"])
            completion(nil, err)
            return
        }
        
        let session = URLSession.init(configuration: .background(withIdentifier: "downloads"))
        
        guard let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        
        session.downloadTask(with: urlRequest) { (tempLocalUrl, response, error) in
            if let _ = error {
                completion(nil, error)
                return
            }
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                print("Success: \(statusCode)")
            }
            
            completion(tempLocalUrl, nil)
            
        }.resume()
        
    }
}
