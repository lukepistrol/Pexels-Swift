//
//  PSCollection.swift
//  
//
//  Created by Lukas Pistrol on 12.05.22.
//

import Foundation

/// A structure representing a Collection and its metadata.
public struct PSCollection: Identifiable, Codable, Equatable {

    enum CodingKeys: String, CodingKey {
        case id, title, description
        case isPrivate = "private"
        case mediaCount = "media_count"
        case photosCount = "photos_count"
        case videosCount = "videos_count"
    }

    /// The ID of the collection.
    public var id: String

    /// The name of the collection.
    public var title: String

    /// The description of the collection.
    public var description: String

    /// A flag indicating whether or not the collection is marked as private.
    public var isPrivate: Bool

    /// The total number of media included in this collection.
    public var mediaCount: Int

    /// The total number of photos included in this collection.
    public var photosCount: Int

    /// The total number of videos included in this collection.
    public var videosCount: Int

}
