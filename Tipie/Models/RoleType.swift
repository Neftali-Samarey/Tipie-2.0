//
//  RoleType.swift
//  Tipie
//
//  Created by Neftali Samarey on 7/27/26.
//

import Foundation

/// `RoleType` - defines the type of role each display will be.
/// i.e Display is of role type due, we'd display a receipt icon, and "due" title
enum RoleType {
    case due
    case tip
    case total
    
    var title: String {
        switch self {
        case .due: return "Due"
        case .tip: return "Tip"
        case .total: return "Total"
        }
    }
    
    var iconString: String {
        switch self {
        case .due: return "receipt"
        case .tip: return "dollarsign.circle"
        case .total: return "cart.fill"
        }
    }
}
