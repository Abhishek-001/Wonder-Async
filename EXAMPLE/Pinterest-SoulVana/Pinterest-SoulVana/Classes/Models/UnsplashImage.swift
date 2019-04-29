//
//  Unsplash.swift
//  Pinterest-SoulVana
//
//  Created by Abhishek.Rathi on 23/04/19.
//  Copyright © 2019 Abhishek.Rathi. All rights reserved.
//

import Foundation
import Wonder_Async

class UnsplashImage: Decodable {
    
    let id: String
    let createdAt: String
    let width, height: Int
    let color: String
    let likes: Int
    let likedByUser: Bool
    let user: User
    let urls: Urls
    let categories: [Category]
    let links: Links
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height, color, likes
        case likedByUser = "liked_by_user"
        case user
        case urls, categories, links
    }
    
    init(id: String, createdAt: String, width: Int, height: Int, color: String, likes: Int, likedByUser: Bool, user: User, urls: Urls, categories: [Category], links: Links) {
        self.id = id
        self.createdAt = createdAt
        self.width = width
        self.height = height
        self.color = color
        self.likes = likes
        self.likedByUser = likedByUser
        self.user = user
        self.urls = urls
        self.categories = categories
        self.links = links
    }
}

class Category: Decodable {
    let id: Int
    let title: String
    let photoCount: Int
    let links: CategoryLinks
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case photoCount = "photo_count"
        case links
    }
    
    init(id: Int, title: String, photoCount: Int, links: CategoryLinks) {
        self.id = id
        self.title = title
        self.photoCount = photoCount
        self.links = links
    }
}

class CategoryLinks: Decodable {
    let linksSelf, photos: String
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case photos
    }
    
    init(linksSelf: String, photos: String) {
        self.linksSelf = linksSelf
        self.photos = photos
    }
}


class Links: Decodable {
    let linksSelf: String
    let html, download: String
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
    }
    
    init(linksSelf: String, html: String, download: String) {
        self.linksSelf = linksSelf
        self.html = html
        self.download = download
    }
}

class Urls: Decodable {
    let raw, full, regular, small: String
    let thumb: String
    
    init(raw: String, full: String, regular: String, small: String, thumb: String) {
        self.raw = raw
        self.full = full
        self.regular = regular
        self.small = small
        self.thumb = thumb
    }
}

class User: Decodable {
    let id, username, name: String
    let profileImage: ProfileImage
    let links: UserLinks
    
    enum CodingKeys: String, CodingKey {
        case id, username, name
        case profileImage = "profile_image"
        case links
    }
    
    init(id: String, username: String, name: String, profileImage: ProfileImage, links: UserLinks) {
        self.id = id
        self.username = username
        self.name = name
        self.profileImage = profileImage
        self.links = links
    }
}

class UserLinks: Decodable {
    let linksSelf: String
    let html: String
    let photos, likes: String
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes
    }
    
    init(linksSelf: String, html: String, photos: String, likes: String) {
        self.linksSelf = linksSelf
        self.html = html
        self.photos = photos
        self.likes = likes
    }
}

class ProfileImage: Decodable {
    let small, medium, large: String
    
    init(small: String, medium: String, large: String) {
        self.small = small
        self.medium = medium
        self.large = large
    }
}


extension UnsplashImage {
    
    static func getImages(urlString : String , completion: @escaping (([UnsplashImage]) -> ())){
        WebService.sharedInstance.callRestApi(urlString: urlString, httpMethod: .get) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            do {
                let images = try JSONDecoder().decode([UnsplashImage].self, from: data!)
                completion(images)
                
            } catch {
                print(error)
            }
        }
    }
}
