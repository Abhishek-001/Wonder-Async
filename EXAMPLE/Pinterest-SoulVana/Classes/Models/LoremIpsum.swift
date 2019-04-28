//
//  LoremIpsum.swift
//  Pinterest-SoulVana
//
//  Created by Abhishek.Rathi on 23/04/19.
//  Copyright © 2019 Abhishek.Rathi. All rights reserved.
//

import Foundation

class LorumIpsum : Decodable {
    let id, author: String
    let width, height: Int
    let url, downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
    
    init(id: String, author: String, width: Int, height: Int, url: String, downloadURL: String) {
        self.id = id
        self.author = author
        self.width = width
        self.height = height
        self.url = url
        self.downloadURL = downloadURL
    }
    
}
