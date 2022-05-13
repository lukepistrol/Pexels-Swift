//
//  File.swift
//  
//
//  Created by Lukas Pistrol on 12.05.22.
//

import Foundation

public struct PSPhoto: Identifiable, Codable, Equatable {

    enum CodingKeys: String, CodingKey {
        case id, url, width, height, photographer
        case alternateDescription = "alt"
        case source = "src"
        case photographerURL = "photographer_url"
        case photographerID = "photographer_id"
        case averageColor = "avg_color"
    }

    public var id: Int
    public var width: Int
    public var height: Int
    public var url: String
    public var photographer: String
    public var photographerURL: String
    public var photographerID: Int
    public var averageColor: String
    public var source: Dictionary<Size.RawValue,String>
    public var alternateDescription: String

    public enum Size: String {
        case original, large2x, large, medium, small, portrait, landscape, tiny
    }

}
