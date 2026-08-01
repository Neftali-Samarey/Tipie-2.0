//
//  ContentView.swift
//  Tipie
//
//  Created by Neftali Samarey on 7/27/26.
//

import SwiftUI

enum ActiveTipElement {
    case fifteen
    case eighteen
    case twenty
    case custom

    /// Tip percentage associated with the preset. `custom` has no fixed value
    /// and keeps whatever percentage is currently set.
    var percentage: Double? {
        switch self {
        case .fifteen: return 15
        case .eighteen: return 18
        case .twenty: return 20
        case .custom: return nil
        }
    }
}

struct ContentView: View {
    
    @State private var viewModel = CalculationViewModel()
    @State private var splitViewEnabled: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    LinearGradient(
                        colors: [
                            .tipiePurple,
                            .tipieDisplayBlue
                        ],
                        startPoint: .topLeading,
                        endPoint: .topTrailing
                    )
                    .ignoresSafeArea()

                    VStack {
                        Spacer()

                        Color.white
                            .frame(height: geometry.safeAreaInsets.bottom)
                            .ignoresSafeArea(edges: .bottom)
                    }

                    VStack(spacing: .zero) {
                        displaySegmentView
                            .frame(height: geometry.size.height * 0.45)

                        keyboardBottomView
                            .frame(height: geometry.size.height * 0.55)
                    }
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        HapticFeedbackService.vibrate(.selection)
                        splitViewEnabled = true
                    } label: {
                        if let splitIcon = UIImage(named: "SplitIcon") {
                            Image(uiImage: splitIcon)
                        }
                    }
                }
            }
            .sheet(isPresented: $splitViewEnabled) {
                Text("Sheet Content")
                    .presentationDetents([.medium])
            }
        }
    }
}

// MARK: Display

fileprivate extension ContentView {
    var displaySegmentView: some View {
        VStack(spacing: 15) {
            VStack(spacing: .zero) {
                DisplayView(type: .due, separatorVisible: true, value: viewModel.dueDisplay)
                DisplayView(type: .tip, separatorVisible: true, value: viewModel.tipDisplay)
                DisplayView(type: .total, separatorVisible: false, value: viewModel.totalDisplay)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .layoutPriority(1)

            tipPresetsView
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
       // .border(Color.red)
    }
}

// MARK: Tip Presets

fileprivate extension ContentView {
    var tipPresetsView: some View {
        HStack(spacing: .zero) {
            tipPreset("15%", isSelected: viewModel.activeTipElement == .fifteen) {
                viewModel.activeTipElement = .fifteen
            }

            tipPreset("18%", isSelected: viewModel.activeTipElement == .eighteen) {
                viewModel.activeTipElement = .eighteen
            }

            tipPreset("20%", isSelected: viewModel.activeTipElement == .twenty) {
                viewModel.activeTipElement = .twenty
            }

            tipPreset("Custom", isSelected: viewModel.activeTipElement == .custom) {
                viewModel.activeTipElement = .custom
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.2))
        )
        .padding(.horizontal, 15)
    }

    @ViewBuilder
    private func tipPreset(
        _ title: String,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            HapticFeedbackService.vibrate(.selection)
            action()
        } label: {
            Text(title)
                .frame(maxWidth: .infinity, minHeight: 35)
                .font(.system(.body, design: .rounded))
                .bold()
                .padding(.vertical, 8)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            isSelected
                            ? Color.white.opacity(0.25)
                            : Color.clear
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: Keyboard

fileprivate extension ContentView {
    var keyboardBottomView: some View {
        VStack(spacing: .zero) {
            KeyboardView { action in
                viewModel.handleKeyboard(action)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 24,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 24
            )
        )
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

#Preview {
    ContentView()
}
