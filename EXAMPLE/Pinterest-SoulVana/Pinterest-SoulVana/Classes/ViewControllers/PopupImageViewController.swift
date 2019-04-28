//
//  PopupImageViewController.swift
//  Pinterest-SoulVana
//
//  Created by Abhishek.Rathi on 26/04/19.
//  Copyright © 2019 Abhishek.Rathi. All rights reserved.
//

import UIKit
import Wonder_Async

class PopupImageViewController : UIViewController {
    
    @IBOutlet weak var popupImageView: CachedImageView!
    @IBOutlet weak var closeButton: UIButton!
    var imageUrl = ""
    
    override func viewWillAppear(_ animated: Bool) {
        appearAnimation()
        popupImageView.loadImage(urlString: imageUrl  + "?&w=\(view.frame.width)&h=\(view.frame.height)")
    }
    
    override func viewDidLoad() {
        popupImageView.contentMode = .scaleAspectFill
        popupImageView.clipsToBounds = true
        popupImageView.alpha = 0
        popupImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    }
    
    fileprivate func appearAnimation() {
        
        UIView.animate(withDuration: 0.2) {
            self.popupImageView.alpha = 1
            self.popupImageView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        UIView.animate(withDuration: 0.15, animations: {
            self.popupImageView.alpha = 0
            self.popupImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (Bool) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
