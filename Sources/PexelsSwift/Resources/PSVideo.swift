//
//  PSVideo.swift
//  
//
//  Created by Lukas Pistrol on 13.05.22.
//

import Foundation

/// A structure representing a Video and its metadata.
public struct PSVideo: Identifiable, Codable, Equatable {

    enum CodingKeys: String, CodingKey {
        case id, width, height, url, image, duration, user
        case videoFiles = "video_files"
        case videoPictures = "video_pictures"
    }

    /// The ID of the video.
    public var id: Int

    /// The real width of the video in pixels.
    public var width: Int

    /// The real height of the video in pixels.
    public var height: Int

    /// The Pexels URL where the video is located.
    public var url: String

    /// URL to a screenshot of the video.
    public var image: String

    /// The duration of the video in seconds.
    public var duration: Int

    /// The videographer who shot the video.
    public var user: Videographer

    /// An array of different sized versions of the video.
    public var videoFiles: [File]

    /// An array of preview pictures of the video.
    public var videoPictures: [Preview]

    /// A structure representing a videographer
    public struct Videographer: Identifiable, Codable, Equatable {

        /// The ID of the videographer.
        public var id: Int

        /// The name of the videographer.
        public var name: String

        /// The URL of the videographer's Pexels profile.
        public var url: String
    }

    /// A structure representing a video file and its metadata.
    public struct File: Identifiable, Codable, Equatable {
        enum CodingKeys: String, CodingKey {
            case id, width, height, link, quality
            case fileType = "file_type"
        }

        /// The ID of the ``PSVideo/File``.
        public var id: Int

        /// The quality of the ``PSVideo/File``.
        public var quality: Quality

        /// The video format.
        public var fileType: String

        /// The width in pixels.
        public var width: Int?

        /// The height in pixels
        public var height: Int?

        /// The frames per second of the ``PSVideo/File``.
        public var fps: Double?

        /// A link to where the ``PSVideo/File`` is hosted.
        public var link: String

        /// A collection of possible video qualities `[hd, sd, hls]`.
        public enum Quality: String, Codable {
            case hd, sd, hls
        }
    }

    /// A structure representing a preview picture of a video.
    public struct Preview: Identifiable, Codable, Equatable {
        enum CodingKeys: String, CodingKey {
            case id
            case link = "picture"
            case index = "nr"
        }

        /// The ID of the ``PSVideo/Preview``.
        public var id: Int

        /// A link to the preview image.
        public var link: String

        /// The index in the array.
        public var index: Int
    }
}
