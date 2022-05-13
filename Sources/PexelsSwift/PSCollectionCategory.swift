//
//  File.swift
//  
//
//  Created by Lukas Pistrol on 12.05.22.
//

import Foundation

/// A structure representing a Collection Category and its metadata.
public struct CollectionCategory: Identifiable, Codable, Equatable {

    enum CodingKeys: String, CodingKey {
        case id, title, description
        case isPrivate = "private"
        case mediaCount = "media_count"
        case photosCount = "photos_count"
        case videosCount = "videos_count"
    }

    public var id: String
    public var title: String
    public var description: String
    public var isPrivate: Bool
    public var mediaCount: Int
    public var photosCount: Int
    public var videosCount: Int 

}
