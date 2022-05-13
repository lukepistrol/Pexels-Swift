//
//  File.swift
//  
//
//  Created by Lukas Pistrol on 13.05.22.
//

import Foundation

internal extension PexelsSwift {
    func url(for type: StreamType, collectionID: String) -> URLComponents {
        switch type {
        case .curated: return URLComponents(string: PSURL.curated)!
        case .search: return URLComponents(string: PSURL.search)!
        case .collections: return URLComponents(string: PSURL.collections + "/" + collectionID)!
        }
    }
}
