//
//  CacheManager.swift
//  Pinterest-SoulVana
//
//  Created by Abhishek.Rathi on 25/04/19.
//  Copyright © 2019 Abhishek.Rathi. All rights reserved.
//

import Foundation

public class CacheManager: NSObject {
    
    public static var shared = CacheManager()
    public var cache : URLCache!
    
    public func setupCache(memoryCapacityMB: Int){
        let memoryCapacityBytes = memoryCapacityMB * 1024 * 1024
        self.cache = URLCache(memoryCapacity: memoryCapacityBytes, diskCapacity: 0, diskPath: nil)
        URLCache.shared = cache

    }
    
    public func saveInCache(urlString : String , data: Data, response: URLResponse){
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        let cachedData = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedData, for: request)
    }
    
    public func fetchFromCache(urlString : String) -> Data? {
        guard let url = URL(string: urlString) else { return nil }
        let request = URLRequest(url: url)
        
        if let cachedUrlResponse = URLCache.shared.cachedResponse(for: request) {
         return cachedUrlResponse.data
        }
        else{
            return nil
        }
    }
}
