//
//  Icons.swift
//  Tipie
//
//  Created by Neftali Samarey on 8/4/26.
//

import Foundation

enum Icons {
    case trash
    case split
    
    var value: String {
        switch self {
        case .trash: "trash"
        case .split: "SplitIcon"
        }
    }
}
