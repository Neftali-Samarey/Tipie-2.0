//
//  StringLegend.swift
//  Tipie
//
//  Created by Neftali Samarey on 8/4/26.
//

public enum StringLegend {
    case custom
    case minus
    case plus
    case splitBill
    case settings
    case general
    case about
    case aboutTagline
    case rateApp
    case version
    case build
    case done
    
    var value: String {
        switch self {
        case .custom: "Custom Tip"
        case .minus: "-"
        case .plus: "+"
        case .splitBill: "Split Bill"
        case .settings: "Settings"
        case .general: "General"
        case .about: "About"
        case .aboutTagline: "Design & Development by Neftali Samarey"
        case .rateApp: "Rate Tipie"
        case .version: "Version"
        case .build: "Build"
        case .done: "Done"
        }
    }
}
