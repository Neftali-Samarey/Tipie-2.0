//
//  StyledButton.swift
//  Tipie
//
//  Created by Neftali Samarey on 8/4/26.
//

import SwiftUI

struct StyledButton: View {

    let title: String
    let action: () -> Void

    var body: some View {
        Button {
            HapticFeedbackService.vibrate(.selection)
            action()
        } label: {
            Text(title)
                .font(.system(size: Constants.fontSize, weight: .medium))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: Constants.frameHeight)
                .background(
                    RoundedRectangle(cornerRadius: Constants.cornerRounding)
                        .fill(LinearGradient.buttonGradient)
                )
        }
        .buttonStyle(.plain)
    }
}

fileprivate extension StyledButton {
    enum Constants {
        static let cornerRounding: CGFloat = 12.0
        static let fontSize: CGFloat = 20.0
        static let frameHeight: CGFloat = 55.0
    }
}

#Preview {
    StyledButton(title: "Done", action: {})
}
