//
//  Category.swift
//  SampleApp
//
//  Created by Daniel Velikov on 14.05.24.
//

import UIKit

enum Category: String, Decodable {
    case football = "FOOT"
    case basketball = "BASK"
    case tennis = "TENN"
    case tableTennis = "TABL"
    case volleyball = "VOLL"
    case esports = "ESPS"
    case handball = "HAND"
    case snooker = "SNOO"
    case futsal = "FUTS"
    case darts = "DART"
    case hockey = "ICEH"
    
    var icon: UIImage {
        switch self {
        case .football:
            return .footballIcon
        case .basketball:
            return .basketballIcon
        case .tennis:
            return .tennisIcon
        case .volleyball:
            return .volleyballIcon
        case .snooker, .hockey:
            return .snookerIcon
        case .esports:
            return .esportsIcon
        case .darts:
            return .dartsIcon
        case .handball:
            return .handballIcon
        case .futsal:
            return .futsalIcon
        case .tableTennis:
            return .tableTennisIcon
        }
    }
}
