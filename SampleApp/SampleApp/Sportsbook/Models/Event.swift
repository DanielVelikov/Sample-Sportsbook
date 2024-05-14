//
//  Event.swift
//  SampleApp
//
//  Created by Daniel Velikov on 14.05.24.
//

import Foundation

struct Event: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "i"
        case name = "d"
        case category = "si"
        case startTime = "tt"
    }
    
    private let name: String
    
    let id: String
    let category: Category
    let startTime: Int
    var isFavourite = false // should be coming from BE tbh
    
    var participants: (first: String, second: String?) {
        let participants = name.split(separator: "-").map { String($0) }
        
        guard participants.count == 2 else { return (name, nil) }
        return (participants[0], participants[1])
    }
}
