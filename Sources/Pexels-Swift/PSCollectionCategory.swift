//
//  File.swift
//  
//
//  Created by Lukas Pistrol on 12.05.22.
//

import Foundation

public struct CollectionCategory: Identifiable, Codable, Equatable {

    public var id: String
    public var description: String

    public var titleText: String { title.trimmingCharacters(in: .whitespaces) }
    public var photosCount: Int { photos_count }

    private var title: String
    private var media_count: Int
    private var photos_count: Int
    private var videos_count: Int

}
