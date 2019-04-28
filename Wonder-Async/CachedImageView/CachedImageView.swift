//
//  CachedImageView.swift
//  Pinterest-SoulVana
//
//  Created by Abhishek.Rathi on 23/04/19.
//  Copyright © 2019 Abhishek.Rathi. All rights reserved.
//

import Foundation
import UIKit

public class CachedImageView: UIImageView {
    
    public var shouldUseEmptyImage = true
    private var urlStingPlaceholder : String?
    private var emptyImage : UIImage?

    public func loadImage(urlString: String, httpMethod: HTTPMethod = .get, completion: (() -> ())? = nil) {
        image = nil
        
        self.urlStingPlaceholder = urlString
        
        let urlKey = urlString as NSString
     
        // check if Image has been Cached before even going to Webservice class.
        if let data = CacheManager.fetchFromCache(urlString: urlKey as String) {
            if let cachedImage = UIImage(data: data){
                image = cachedImage
                completion?()
                return
            }
        }

        /// TODO :
        //put a placeholder image until Original Image is downloaded.
        if shouldUseEmptyImage {
            image = emptyImage
        }
        
        let activityloader = UIActivityIndicatorView()
        activityloader.color = .gray
        activityloader.startAnimating()
        
        self.addSubview(activityloader)
        activityloader.center = self.center

        WebService.sharedInstance.callRestApi(urlString: urlString, httpMethod: httpMethod) { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                activityloader.stopAnimating()
                
                if let image = UIImage(data: data!){
    
                    if urlString == self?.urlStingPlaceholder {
                        self?.image = image
                        self?.alpha = 0.3
                        UIView.animate(withDuration: 1, animations: {
                            self?.alpha = 1
                        })
                        completion?()
                    }
                }
            }
        }
    }
    
}
