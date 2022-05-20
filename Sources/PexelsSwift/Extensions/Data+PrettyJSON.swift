//
//  Data+PrettyJSON.swift
//  
//
//  Created by Lukas Pistrol on 15.05.22.
//

import Foundation

internal extension Data {
    func prettyJSON() -> String? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            return String(decoding: jsonData, as: UTF8.self)
        }
        return nil
    }
}
