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

        private static let basePath: String = "https://api.pexels.com/"

        private static let version: String = "v1"
        private static let videos: String = "videos"

        static var featuredCollections: String {
            URL(string: basePath)!
                .appendingPathComponent(version)
                .appendingPathComponent("collections")
                .appendingPathComponent("featured")
                .absoluteString
        }

        static func collections(_ id: String) -> String {
            URL(string: basePath)!
                .appendingPathComponent(version)
                .appendingPathComponent("collections")
                .appendingPathComponent(id)
                .absoluteString
        }

        static var searchPhotos: String {
            URL(string: basePath)!
                .appendingPathComponent(version)
                .appendingPathComponent("search")
                .absoluteString
        }

        static var curatedPhotos: String {
            URL(string: basePath)!
                .appendingPathComponent(version)
                .appendingPathComponent("curated")
                .absoluteString
        }

        static func photoByID(_ id: Int) -> String {
            URL(string: basePath)!
                .appendingPathComponent(version)
                .appendingPathComponent("photos")
                .appendingPathComponent(id.string)
                .absoluteString
        }

        static var searchVideos: String {
            URL(string: basePath)!
                .appendingPathComponent(videos)
                .appendingPathComponent("search")
                .absoluteString
        }

        static var popularVideos: String {
            URL(string: basePath)!
                .appendingPathComponent(videos)
                .appendingPathComponent("popular")
                .absoluteString
        }

        static func videoByID(_ id: Int) -> String {
            URL(string: basePath)!
                .appendingPathComponent(videos)
                .appendingPathComponent("videos")
                .appendingPathComponent(id.string)
                .absoluteString
        }
    }
}
