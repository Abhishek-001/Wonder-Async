//
//  InternetManager.swift
//  Pinterest-SoulVana
//
//  Created by Abhishek.Rathi on 22/04/19.
//  Copyright © 2019 Abhishek.Rathi. All rights reserved.
//

import Foundation
import SystemConfiguration

public class InternetConnectivityManager: NSObject {
    
    static let sharedInstance = InternetConnectivityManager()

    // Checks if Device is connected to Internet & returns boolian accordingly.
    public func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
}
