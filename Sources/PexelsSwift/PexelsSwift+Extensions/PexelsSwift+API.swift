//
//  PexelsSwift+API.swift
//  
//
//  Created by Lukas Pistrol on 12.05.22.
//

import Foundation

internal extension PexelsSwift {
    /// A collection of API endpoints/routes.
    enum API {
        static let featuredCollections: String = "https://api.pexels.com/v1/collections/featured"
        static let searchPhotos: String = "https://api.pexels.com/v1/search"
        static let searchVideos: String = "https://api.pexels.com/videos/search"
        static let curatedPhotos: String = "https://api.pexels.com/v1/curated"
        static let popularVideos: String = "https://api.pexels.com/videos/popular"
        static let photoByID: String = "https://api.pexels.com/v1/photos"
        static let videoByID: String = "https://api.pexels.com/videos/videos"

        static func collections(_ id: String) -> String {
            "https://api.pexels.com/v1/collections".appending("/\(id)")
        }
    }
}
