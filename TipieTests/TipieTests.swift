//
//  TipieTests.swift
//  TipieTests
//
//  Created by Neftali Samarey on 7/27/26.
//

import Testing
@testable import Tipie

struct TipieTests {
    @Test("Test view model predefined tip percentile functionality")
    @MainActor
    func testViewModelPredefinedTipPercentile() async throws {
        // preparation
        let viewModel = CalculationViewModel()
        viewModel.handleKeyboard(.keyPressed("125.00"))

        // sanity check: the default preset is 15%
        #expect(viewModel.activeTipElement == .fifteen)
        #expect(viewModel.tipPercentage == 15)

        // execution & verification: each preset maps to the correct percentage,
        // tip, and total for a $125.00 bill.
        let expectations: [(element: ActiveTipElement, percentage: Double, tip: Double, total: Double)] = [
            (.fifteen, 15, 18.75, 143.75),
            (.eighteen, 18, 22.5, 147.5),
            (.twenty, 20, 25, 150)
        ]

        for expectation in expectations {
            viewModel.activeTipElement = expectation.element

            #expect(viewModel.tipPercentage == expectation.percentage)
            #expect(viewModel.tipValue == expectation.tip)
            #expect(viewModel.totalValue == expectation.total)
        }

        // the custom preset uses its associated amount as the tip percentage
        viewModel.activeTipElement = .custom(amount: 22)
        #expect(viewModel.tipPercentage == 22)
        #expect(viewModel.tipValue == 27.5)
        #expect(viewModel.totalValue == 152.5)
    }
}
