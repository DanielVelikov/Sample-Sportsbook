//
//  EventList.swift
//  SampleApp
//
//  Created by Daniel Velikov on 14.05.24.
//

import Foundation

struct EventList: Decodable {
    private enum CodingKeys: String, CodingKey {
        case category = "i"
        case name = "d"
        case events = "e"
    }
    
    let category: Category
    let name: String
    var events: [Event] {
        didSet {
            events.sort(by: { $0.isFavourite && $1.isFavourite == false })
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.category = try container.decode(Category.self, forKey: .category)
        self.name = try container.decode(String.self, forKey: .name)
        self.events = try container.decode([Event].self, forKey: .events).filter { $0.startTime.asDate.isPastEvent == false }
    }
}
