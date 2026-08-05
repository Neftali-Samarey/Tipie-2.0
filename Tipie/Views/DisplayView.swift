//
//  DisplayView.swift
//  Tipie
//
//  Created by Neftali Samarey on 7/27/26.
//

import SwiftUI

struct DisplayView: View {

    private let type: RoleType
    private let separatorVisible: Bool
    private let value: String

    public init(type: RoleType, separatorVisible: Bool, value: String) {
        self.type = type
        self.separatorVisible = separatorVisible
        self.value = value
    }
    
    var body: some View {
        display
    }
}

// MARK: View Configurations

fileprivate extension DisplayView {
    var display: some View {
        VStack {
            HStack(spacing: 12) {
                ZStack {
                    Image(systemName: type.iconString)
                        .font(.body)
                        .foregroundStyle(Color.white)
                }
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.2))
                )

                Text(type.title)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .textCase(.uppercase)
                    .font(.footnote)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.white)

                Text(value)
                    .monospacedDigit()
                    .bold()
                    .foregroundStyle(Color.white)
                    .contentTransition(.numericText())
                    .animation(.snappy, value: value)
            }
            .font(.system(.title2, design: .rounded))
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            
            if separatorVisible {
                Divider()
                    .background(Color.white)
                    .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    Group {
        VStack(spacing: .zero) {
            DisplayView(type: .due, separatorVisible: true, value: "$160.00")
            DisplayView(type: .tip, separatorVisible: true, value: "$24.00")
            DisplayView(type: .total, separatorVisible: false, value: "$184.00")
        }
        .background(LinearGradient(
            colors: [
                .tipiePurple,
                .tipieDisplayBlue
            ],
            startPoint: .topLeading,
            endPoint: .topTrailing
        ))
    }
}
