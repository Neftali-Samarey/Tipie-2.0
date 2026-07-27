//
//  DisplayView.swift
//  Tipie
//
//  Created by Neftali Samarey on 7/27/26.
//

import SwiftUI

struct DisplayView: View {
    
    private let type: RoleType
    
    public init(type: RoleType) {
        self.type = type
    }
    
    var body: some View {
        display
    }
}

// MARK: View Configurations

fileprivate extension DisplayView {
    var display: some View {
        HStack(spacing: 12) {
            Image(systemName: type.iconString)
                .frame(width: 24, alignment: .center)

            Text(type.title)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("$145.00")
                .monospacedDigit()
        }
        .font(.system(.title2, design: .rounded))
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
    }
}

#Preview {
    Group {
        VStack {
            DisplayView(type: .due)
            DisplayView(type: .tip)
            DisplayView(type: .total)
        }
    }
}
