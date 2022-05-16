//
//  PSPhoto.swift
//  
//
//  Created by Lukas Pistrol on 12.05.22.
//

import Foundation

/// A structure representing a Photo and its metadata.
public struct PSPhoto: Identifiable, Codable, Equatable {

    enum CodingKeys: String, CodingKey {
        case id, url, width, height, photographer
        case alternateDescription = "alt"
        case source = "src"
        case photographerURL = "photographer_url"
        case photographerID = "photographer_id"
        case averageColor = "avg_color"
    }

    /// The id of the photo.
    public var id: Int

    /// The real width of the photo in pixels.
    public var width: Int

    /// The real height of the photo in pixels
    public var height: Int

    /// The Pexels URL where the photo is located.
    public var url: String

    /// The name of the photographer who took the photo.
    public var photographer: String

    /// The URL of the photographer's Pexels profile.
    public var photographerURL: String

    /// The ID of the photographer.
    public var photographerID: Int

    /// The average color of the photo. Useful for a placeholder while the image loads.
    public var averageColor: String

    /// A collection of URLs of different image sizes that can be used to display this ``PSPhoto``.
    public var source: Dictionary<Size.RawValue,String>

    /// Text description of the photo for use in the `alt` attribute (HTML).
    public var alternateDescription: String

    /// Keys for different image sizes that can be used to display this ``PSPhoto``
    public enum Size: String {
        
        /// The image without any size changes. It will be the same as the ``PSPhoto/width`` and ``PSPhoto/height`` attributes.
        case original

        /// the image resized to `940px X 650px @2x`
        case large2x

        /// the image resized to `940px X 650px`
        case large

        /// The image scaled proportionally so that it's new height is `350px`
        case medium

        /// The image scaled proportionally so that it's new height is `130px`
        case small

        /// The image cropped to `800px X 1200px`
        case portrait

        /// The image cropped to `1200px X 627px`
        case landscape

        /// The image cropped to `280px X 200px`
        case tiny
    }

}
