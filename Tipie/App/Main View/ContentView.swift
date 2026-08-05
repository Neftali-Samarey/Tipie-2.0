//
//  ContentView.swift
//  Tipie
//
//  Created by Neftali Samarey on 7/27/26.
//

import SwiftUI

enum ActiveTipElement: Equatable, CaseIterable {

    case fifteen
    case eighteen
    case twenty
    case custom(amount: Double)

    /// Tip percentage associated with the preset. For `custom`, the associated
    /// amount is used directly as the percentage.
    var percentage: Double {
        switch self {
        case .fifteen: return 15
        case .eighteen: return 18
        case .twenty: return 20
        case .custom(let amount): return amount
        }
    }

    /// Whether this element is the custom preset, regardless of its amount.
    var isCustom: Bool {
        if case .custom = self { return true }
        return false
    }

    /// `custom` carries an associated value, so `allCases` can't be synthesized
    /// automatically. It's represented here with a default amount as a placeholder.
    static var allCases: [ActiveTipElement] {
        [.fifteen, .eighteen, .twenty, .custom(amount: 0)]
    }
}

struct ContentView: View {

    /// Identifies which modal the sheet should present, independent of the
    /// current tip selection.
    private enum ModalRoute: Identifiable {
        case custom
        case split

        var id: Self { self }
    }

    @Environment(\.colorScheme) private var colorScheme
    
    @State private var viewModel = CalculationViewModel()
    @State private var modalRoute: ModalRoute?
    
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
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: Constants.iconSpacing) {
                        Button {
                            HapticFeedbackService.vibrate(.selection)
                            // TODO: trigger info view
                        } label: {
                            Image(systemName: Icons.info.value)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .sharedBackgroundVisibility(.hidden)

                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: Constants.iconSpacing) {
                        // split
                        Button {
                            HapticFeedbackService.vibrate(.selection)
                            modalRoute = .split
                        } label: {
                            if let splitIcon = UIImage(named: Icons.split.value) {
                                Image(uiImage: splitIcon)
                                    .renderingMode(.template)
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        // trash
                        Button {
                            HapticFeedbackService.vibrate(.selection)
                            viewModel.reset()
                        } label: {
                            Image(systemName: Icons.trash.value)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .sheet(item: $modalRoute) { route in
                Group {
                    switch route {
                    case .custom:
                        customControlView
                    case .split:
                        splitContentView
                    }
                }
                .presentationDetents([.medium])
                .interactiveDismissDisabled()
                .preferredColorScheme(.light)
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

            tipPreset("Custom", isSelected: viewModel.activeTipElement.isCustom) {
                viewModel.activeTipElement = .custom(amount: 50.0)
                modalRoute = .custom
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

// MARK: Custom Input View

fileprivate extension ContentView {
    var customControlView: some View {
        VStack(spacing: 24) {
            Text(StringLegend.custom.value)
                .font(.system(size: 21, weight: .medium))

            Spacer()

            VStack(spacing: 20) {
                // todo
            }

            Spacer()

            StyledButton(title: "Done") {
                modalRoute = nil
            }
        }
        .padding(20)
    }
}

// MARK: Reuseable views

fileprivate extension ContentView {
    var stepperView: some View {
        HStack(spacing: .zero) {
            // decrement view
            Button {
                guard viewModel.numberOfSplit > 1 else { return }
                HapticFeedbackService.vibrate(.selection)
                viewModel.numberOfSplit -= 1
            } label: {
                Text(StringLegend.minus.value)
                    .font(.system(size: 22)).bold()
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(LinearGradient.buttonGradient)
                    .opacity(viewModel.numberOfSplit <= 1 ? 0.5 : 1)
                    .disabled(viewModel.numberOfSplit <= 1)
                    .animation(.easeOut(duration: 0.3), value: viewModel.numberOfSplit <= 1)
            }

            // center view label
            Text("\(viewModel.numberOfSplit)")
                .font(.system(size: 22)).bold()
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // increment view
            Button {
                viewModel.numberOfSplit += 1
                HapticFeedbackService.vibrate(.selection)
            } label: {
                Text(StringLegend.plus.value)
                    .font(.system(size: 22)).bold()
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(LinearGradient.buttonGradient)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .frame(height: 45)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

fileprivate extension ContentView {
    var splitContentView: some View {
        VStack(spacing: 24) {
            Text(StringLegend.splitBill.value)
                .font(.system(size: 21, weight: .medium))

            Spacer()

            VStack(spacing: 20) {
                stepperView

                Divider()

                VStack(spacing: 10) {
                    Text(viewModel.numberOfSplit > 1 ? "Each Person Pays" : "You Pay")
                        .font(.body)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .foregroundStyle(.secondary)

                    Text(viewModel.perPersonDisplay)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .contentTransition(.numericText())
                        .animation(.snappy, value: viewModel.numberOfSplit)
                }
            }

            Spacer()

            StyledButton(title: "Done") {
                modalRoute = nil
            }
        }
        .padding(20)
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

// MARK: Constants
fileprivate extension ContentView {
    enum Constants {
        static let iconSpacing: CGFloat = 15
    }
}

#Preview {
    ContentView()
}
