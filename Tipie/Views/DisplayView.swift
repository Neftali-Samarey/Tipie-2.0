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
    private let percentile: String?
    private let value: String

    public init(type: RoleType, separatorVisible: Bool, percentile: String? = nil, value: String) {
        self.type = type
        self.separatorVisible = separatorVisible
        self.percentile = percentile
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
                .accessibilityHidden(true)

                HStack(spacing: 15) {
                    Text(type.title)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .textCase(.uppercase)
                        .font(.footnote)
                        .bold()
                        .foregroundStyle(Color.white)
                        .layoutPriority(1)
                    
                    if type == .tip, let percentileStringValue {
                        Text(percentileStringValue)
                            .lineLimit(1)
                            .textCase(.uppercase)
                            .font(.footnote)
                            .bold()
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white.opacity(0.2))
                            )
                            .fixedSize()
                            .transition(.move(edge: .leading).combined(with: .opacity))
                    }

                    Spacer(minLength: 0)
                }
                .animation(.snappy, value: percentileStringValue)

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
            .accessibilityElement(children: .combine)
            
            if separatorVisible {
                Divider()
                    .background(Color.white)
                    .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: General value configurations

fileprivate extension DisplayView {
    var percentileStringValue: String? {
        guard let value = percentile, value.isEmpty == false else { return nil }
        return value
    }
}

#Preview {
    Group {
        VStack(spacing: .zero) {
            DisplayView(type: .due, separatorVisible: true, value: "$160.00")
            DisplayView(type: .tip, separatorVisible: true, percentile: "50%", value: "824.00")
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
