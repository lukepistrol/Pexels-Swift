//
//  File.swift
//  
//
//  Created by Lukas Pistrol on 12.05.22.
//

import Foundation

public struct PSPhoto: Identifiable, Codable, Equatable {

    public var id: Int
    public var url: String

    public var width: Int
    public var height: Int

    public var src: Dictionary<Size.RawValue,String>

    public var avgColor: String { return avg_color }

    public var photographer: String

    private var photographer_url: String
    private var photographer_id: Int
    private var avg_color: String

    public enum Size: String {
        case original, large2x, large, medium, small, portrait, landscape, tiny
    }

}
