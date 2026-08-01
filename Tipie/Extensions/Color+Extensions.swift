//
//  Color+Extensions.swift
//  Tipie
//
//  Created by Neftali Samarey on 7/28/26.
//

import SwiftUI

public extension Color {
    // MARK: - Brand Colors

    static let primaryWhite = Color(
        red: 247 / 255,
        green: 247 / 255,
        blue: 247 / 255
    )

    static let tipieMint = Color(
        red: 20 / 255,
        green: 216 / 255,
        blue: 180 / 255
    ) // #14D8B4

    static let tipieBlue = Color(
        red: 25 / 255,
        green: 184 / 255,
        blue: 255 / 255
    ) // #19B8FF

    // MARK: - Display Colors

    static let tipiePurple = Color(
        red: 102 / 255,
        green: 59 / 255,
        blue: 242 / 255
    ) // #663BF2

    static let tipieDisplayBlue = Color(
        red: 43 / 255,
        green: 148 / 255,
        blue: 250 / 255
    ) // #2B94FA
}

public extension LinearGradient {
    /// Primary brand gradient
    static let tipiePrimary = LinearGradient(
        colors: [
            .tipieMint,
            .tipieBlue
        ],
        startPoint: .bottomLeading,
        endPoint: .topTrailing
    )

    /// Calculator display/header gradient
    static let tipieDisplay = LinearGradient(
        colors: [
            .tipiePurple,
            .tipieDisplayBlue
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
