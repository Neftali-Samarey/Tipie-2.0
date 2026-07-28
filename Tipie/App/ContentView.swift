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
}

struct ContentView: View {
    
    @State private var viewModel = CalculationViewModel()
    @State private var splitViewEnabled: Bool = false
    @State private var activeTipElement: ActiveTipElement = .fifteen
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: .zero) {
                    displaySegmentView
                        .frame(height: geometry.size.height * 0.45)
                    keyboardView
                        .frame(height: geometry.size.height * 0.55)
                }
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
            }
            .toolbar {
                /*ToolbarItem(placement: .topBarLeading) {
                    Button {
                    } label: {
                        if let settingsIcon = UIImage(named: "slider") {
                            Image(uiImage: settingsIcon)
                        }
                    }
                }*/

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        splitViewEnabled = true
                    } label: {
                        if let splitIcon = UIImage(named: "SplitIcon") {
                            Image(uiImage: splitIcon)
                        }
                    }
                }
            }
            .sheet(isPresented: $splitViewEnabled) {
                // TODO: - replace this with the UI for splitting the bill
                Text("Sheet Content")
                    .presentationDetents([.medium])
            }
        }
    }
}

// MARK: Display

fileprivate extension ContentView {
    var displaySegmentView: some View {
        VStack(spacing: .zero) {
            VStack(spacing: .zero) {
                DisplayView(type: .due)
                DisplayView(type: .tip)
                DisplayView(type: .total)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .layoutPriority(1)

            tipPresetsView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: Tip Presets

fileprivate extension ContentView {
    var tipPresetsView: some View {
        HStack(spacing: .zero) {
            tipPreset("15%", isSelected: activeTipElement == .fifteen) {
                activeTipElement = .fifteen
            }

            tipPreset("18%", isSelected: activeTipElement == .eighteen) {
                activeTipElement = .eighteen
            }

            tipPreset("20%", isSelected: activeTipElement == .twenty) {
                activeTipElement = .twenty
            }

            tipPreset("Custom", isSelected: activeTipElement == .custom) {
                activeTipElement = .custom
            }
        }
    }

    @ViewBuilder
    private func tipPreset(
        _ title: String,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .frame(maxWidth: .infinity, minHeight: 56)
                .font(.system(.body, design: .rounded))
                .padding(.vertical, 12)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .fill(isSelected ? Color.red.opacity(0.8) : Color.red)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: Keyboard

fileprivate extension ContentView {
    var keyboardView: some View {
        VStack(spacing: .zero) {
            KeyboardView { action in
                viewModel.handleKeyboard(action)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
