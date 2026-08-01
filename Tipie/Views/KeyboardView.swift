//
//  KeyboardView.swift
//  Tipie
//
//  Created by Neftali Samarey on 7/27/26.
//

import SwiftUI

struct KeyboardView: View {
    
    enum Action {
        case keyPressed(String)
        case delete
    }
    
    private let keyboardItems = [
        "1", "2", "3",
        "4", "5", "6",
        "7", "8", "9",
        ".", "0", "trash"
    ]
    
    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 6),
        count: 3
    )
    
    /// Pass a view model to capture item action selections made
    let action: (Action) -> Void

    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 6
            let rows = Int(ceil(Double(keyboardItems.count) / 3.0))

            let availableHeight = max(0, geometry.size.height - CGFloat(rows - 1) * spacing)
            let rawKeyHeight = availableHeight / CGFloat(rows)
            let keyHeight = rawKeyHeight.isFinite ? rawKeyHeight : 0

            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(keyboardItems, id: \.self) { item in
                    
                    Button {
                        if item == "trash" {
                            action(.delete)
                        } else {
                            action(.keyPressed(item))
                        }
                        HapticFeedbackService.vibrate(.selection)
                    } label: {
                        keyLabel(item)
                            .frame(maxWidth: .infinity)
                            .frame(height: keyHeight)
                    }
                    .frame(height: keyHeight)
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func keyLabel(_ item: String) -> some View {
        Group {
            if item == "trash" {
                Image(systemName: "delete.left")
            } else {
                Text(item)
            }
        }
        .font(.system(size: 30, weight: .light, design: .rounded))
    }
}

#Preview {
    KeyboardView(action: {_ in })
}
