//
//  PexelsSwift+API.swift
//  
//
//  Created by Lukas Pistrol on 12.05.22.
//

import Foundation

internal extension PexelsSwift {
    enum API {
        static let collections: String = "https://api.pexels.com/v1/collections"
        static let searchPhotos: String = "https://api.pexels.com/v1/search"
        static let searchVideos: String = "https://api.pexels.com/videos/search"
        static let curatedPhotos: String = "https://api.pexels.com/v1/curated"
        static let popularVideos: String = "https://api.pexels.com/videos/popular"
        static let photoByID: String = "https://api.pexels.com/v1/photos"
        static let videoByID: String = "https://api.pexels.com/videos/videos"
    }
}
