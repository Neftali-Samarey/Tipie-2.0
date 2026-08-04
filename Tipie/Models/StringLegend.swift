//
//  StringLegend.swift
//  Tipie
//
//  Created by Neftali Samarey on 8/4/26.
//

public enum StringLegend {
    case minus
    case plus
    case splitBill
    
    var value: String {
        switch self {
        case .minus: "-"
        case .plus: "+"
        case .splitBill: "Split Bill"
        }
    }
}
