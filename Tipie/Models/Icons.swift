//
//  Icons.swift
//  Tipie
//
//  Created by Neftali Samarey on 8/4/26.
//

import Foundation

enum Icons {
    case info
    case trash
    case split
    case about
    case rate
    
    var value: String {
        switch self {
        case .info: "info.circle"
        case .trash: "trash"
        case .split: "SplitIcon"
        case .about: "info.circle"
        case .rate: "star"
        }
    }
}
