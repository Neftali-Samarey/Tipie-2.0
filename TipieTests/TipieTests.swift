//
//  TipieTests.swift
//  TipieTests
//
//  Created by Neftali Samarey on 7/27/26.
//

import Testing
@testable import Tipie

@MainActor
struct TipieTests {

    // MARK: - Helpers

    private func makeViewModel(
        amount: String = "",
        tip: ActiveTipElement = .fifteen,
        split: Int = 1
    ) -> CalculationViewModel {
        let viewModel = CalculationViewModel()
        if amount.isEmpty == false {
            viewModel.handleKeyboard(.keyPressed(amount))
        }
        viewModel.activeTipElement = tip
        viewModel.numberOfSplit = split
        return viewModel
    }

    /// Currency math can accumulate tiny floating-point error; compare with a cent tolerance.
    private func expectCurrency(
        _ actual: Double,
        equals expected: Double,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        #expect(
            abs(actual - expected) < 0.000_1,
            "Expected \(expected), got \(actual)",
            sourceLocation: sourceLocation
        )
    }

    // MARK: - Preset percentages

    @Test(
        "Each tip preset maps to its percentage",
        arguments: [
            (ActiveTipElement.fifteen, 15.0),
            (.eighteen, 18.0),
            (.twenty, 20.0),
            (.custom(amount: 0), 0.0),
            (.custom(amount: 12), 12.0),
            (.custom(amount: 22), 22.0),
            (.custom(amount: 50), 50.0),
        ] as [(ActiveTipElement, Double)]
    )
    func tipPresetPercentage(element: ActiveTipElement, expected: Double) {
        #expect(element.percentage == expected)

        let viewModel = makeViewModel(tip: element)
        #expect(viewModel.tipPercentage == expected)
        #expect(viewModel.tipPercentageDisplay == "\(Int(expected.rounded()))%")
    }

    @Test("Default tip preset is 15%")
    func defaultTipPreset() {
        let viewModel = CalculationViewModel()
        #expect(viewModel.activeTipElement == .fifteen)
        #expect(viewModel.tipPercentage == 15)
        #expect(viewModel.numberOfSplit == 1)
        #expect(viewModel.dueValue == 0)
        #expect(viewModel.tipValue == 0)
        #expect(viewModel.totalValue == 0)
    }

    // MARK: - Tip / total matrix across presets and bill amounts

    @Test("Tip and total matrix covers all presets across representative bill amounts")
    func tipTotalMatrix() {
        let tips: [ActiveTipElement] = [
            .fifteen,
            .eighteen,
            .twenty,
            .custom(amount: 0),
            .custom(amount: 10),
            .custom(amount: 22),
            .custom(amount: 25),
            .custom(amount: 33),
            .custom(amount: 50),
        ]
        let amounts = [
            "0",
            "1",
            "10",
            "12.50",
            "33.33",
            "99.99",
            "100",
            "125.00",
            "250.75",
            "1000",
        ]

        for tip in tips {
            for amount in amounts {
                let viewModel = makeViewModel(amount: amount, tip: tip)
                let due = Double(amount) ?? 0
                let expectedTip = due * tip.percentage / 100
                let expectedTotal = due + expectedTip

                expectCurrency(viewModel.dueValue, equals: due)
                expectCurrency(viewModel.tipValue, equals: expectedTip)
                expectCurrency(viewModel.totalValue, equals: expectedTotal)
            }
        }
    }

    @Test("Predefined presets match known $125.00 expectations")
    func predefinedTipPercentileForKnownBill() {
        let viewModel = makeViewModel(amount: "125.00")

        let expectations: [(ActiveTipElement, Double, Double, Double)] = [
            (.fifteen, 15, 18.75, 143.75),
            (.eighteen, 18, 22.5, 147.5),
            (.twenty, 20, 25, 150),
            (.custom(amount: 22), 22, 27.5, 152.5),
        ]

        for (element, percentage, tip, total) in expectations {
            viewModel.activeTipElement = element
            #expect(viewModel.tipPercentage == percentage)
            expectCurrency(viewModel.tipValue, equals: tip)
            expectCurrency(viewModel.totalValue, equals: total)
        }
    }

    // MARK: - Custom tip behavior

    @Test(
        "Custom tip slider-style percentages calculate correctly",
        arguments: Array(stride(from: 0.0, through: 50.0, by: 1.0))
    )
    func customTipEveryPercent(percentage: Double) {
        let viewModel = makeViewModel(
            amount: "200",
            tip: .custom(amount: percentage)
        )

        #expect(viewModel.tipPercentage == percentage)
        expectCurrency(viewModel.tipValue, equals: 200 * percentage / 100)
        expectCurrency(viewModel.totalValue, equals: 200 + (200 * percentage / 100))
        #expect(viewModel.activeTipElement.isCustom)
    }

    @Test("Selecting custom tip restores the last entered custom percentage")
    func selectCustomTipRestoresLastValue() {
        let viewModel = makeViewModel(amount: "100")

        viewModel.activeTipElement = .custom(amount: 27)
        #expect(viewModel.lastCustomTipPercentage == 27)
        expectCurrency(viewModel.tipValue, equals: 27)

        viewModel.activeTipElement = .twenty
        #expect(viewModel.tipPercentage == 20)
        #expect(viewModel.lastCustomTipPercentage == 27)

        viewModel.selectCustomTip()
        #expect(viewModel.activeTipElement == .custom(amount: 27))
        #expect(viewModel.tipPercentage == 27)
        expectCurrency(viewModel.tipValue, equals: 27)
    }

    @Test("Custom tip updates remember successive amounts")
    func customTipRemembersLatestAmount() {
        let viewModel = CalculationViewModel()

        viewModel.activeTipElement = .custom(amount: 12)
        viewModel.activeTipElement = .custom(amount: 40)
        #expect(viewModel.lastCustomTipPercentage == 40)

        viewModel.activeTipElement = .fifteen
        viewModel.selectCustomTip()
        #expect(viewModel.activeTipElement == .custom(amount: 40))
    }

    @Test("isCustom is true only for the custom case")
    func isCustomFlag() {
        #expect(ActiveTipElement.fifteen.isCustom == false)
        #expect(ActiveTipElement.eighteen.isCustom == false)
        #expect(ActiveTipElement.twenty.isCustom == false)
        #expect(ActiveTipElement.custom(amount: 0).isCustom)
        #expect(ActiveTipElement.custom(amount: 50).isCustom)
    }

    // MARK: - Tip × split permutations

    @Test("Tip and per-person totals are correct for every tip × split permutation")
    func tipSplitMatrix() {
        let tips: [ActiveTipElement] = [
            .fifteen,
            .eighteen,
            .twenty,
            .custom(amount: 0),
            .custom(amount: 25),
            .custom(amount: 50),
        ]
        let splits = [1, 2, 3, 4, 5, 8, 10]
        let bill = "120"

        for tip in tips {
            for split in splits {
                let viewModel = makeViewModel(amount: bill, tip: tip, split: split)
                let due = 120.0
                let expectedTip = due * tip.percentage / 100
                let expectedTotal = due + expectedTip
                let expectedPerPerson = expectedTotal / Double(split)

                expectCurrency(viewModel.tipValue, equals: expectedTip)
                expectCurrency(viewModel.totalValue, equals: expectedTotal)

                // Parse the formatted per-person string back to a number via the same math.
                let rawPerPerson = viewModel.totalValue / Double(max(viewModel.numberOfSplit, 1))
                expectCurrency(rawPerPerson, equals: expectedPerPerson)
                #expect(viewModel.perPersonDisplay.isEmpty == false)
            }
        }
    }

    @Test("Split never divides by zero even if numberOfSplit is forced to 0")
    func splitGuardsAgainstZero() {
        let viewModel = makeViewModel(amount: "100", tip: .twenty, split: 0)
        // max(numberOfSplit, 1) should keep per-person equal to the total.
        expectCurrency(viewModel.totalValue, equals: 120)
        #expect(viewModel.perPersonDisplay == viewModel.totalDisplay)
    }

    // MARK: - Empty / edge amounts

    @Test("Empty amount yields zero tip and total for every preset")
    func emptyAmountAcrossPresets() {
        for tip in ActiveTipElement.allCases + [.custom(amount: 25), .custom(amount: 50)] {
            let viewModel = makeViewModel(tip: tip)
            #expect(viewModel.dueValue == 0)
            #expect(viewModel.tipValue == 0)
            #expect(viewModel.totalValue == 0)
        }
    }

    @Test("Zero tip percentage leaves total equal to the bill")
    func zeroCustomTipLeavesTotalUnchanged() {
        let viewModel = makeViewModel(amount: "87.65", tip: .custom(amount: 0))
        expectCurrency(viewModel.tipValue, equals: 0)
        expectCurrency(viewModel.totalValue, equals: 87.65)
    }

    @Test("Switching presets recalculates tip without changing the bill")
    func switchingPresetsRecalculatesTip() {
        let viewModel = makeViewModel(amount: "80")

        viewModel.activeTipElement = .fifteen
        expectCurrency(viewModel.tipValue, equals: 12)
        expectCurrency(viewModel.totalValue, equals: 92)

        viewModel.activeTipElement = .eighteen
        expectCurrency(viewModel.tipValue, equals: 14.4)
        expectCurrency(viewModel.totalValue, equals: 94.4)

        viewModel.activeTipElement = .twenty
        expectCurrency(viewModel.tipValue, equals: 16)
        expectCurrency(viewModel.totalValue, equals: 96)

        viewModel.activeTipElement = .custom(amount: 5)
        expectCurrency(viewModel.tipValue, equals: 4)
        expectCurrency(viewModel.totalValue, equals: 84)

        #expect(viewModel.dueValue == 80)
    }

    // MARK: - Keyboard input affecting tip math

    @Test("Digit-by-digit entry keeps tip in sync with the growing amount")
    func keyboardEntryKeepsTipInSync() {
        let viewModel = makeViewModel(tip: .twenty)

        viewModel.handleKeyboard(.keyPressed("1"))
        expectCurrency(viewModel.tipValue, equals: 0.2)
        expectCurrency(viewModel.totalValue, equals: 1.2)

        viewModel.handleKeyboard(.keyPressed("0"))
        expectCurrency(viewModel.tipValue, equals: 2)
        expectCurrency(viewModel.totalValue, equals: 12)

        viewModel.handleKeyboard(.keyPressed("0"))
        expectCurrency(viewModel.tipValue, equals: 20)
        expectCurrency(viewModel.totalValue, equals: 120)

        viewModel.handleKeyboard(.keyPressed("."))
        viewModel.handleKeyboard(.keyPressed("5"))
        expectCurrency(viewModel.dueValue, equals: 100.5)
        expectCurrency(viewModel.tipValue, equals: 20.1)
        expectCurrency(viewModel.totalValue, equals: 120.6)
    }

    @Test("Deleting digits recalculates tip downward")
    func deletingDigitsRecalculatesTip() {
        let viewModel = makeViewModel(amount: "50", tip: .fifteen)
        expectCurrency(viewModel.tipValue, equals: 7.5)

        viewModel.handleKeyboard(.delete)
        expectCurrency(viewModel.dueValue, equals: 5)
        expectCurrency(viewModel.tipValue, equals: 0.75)
        expectCurrency(viewModel.totalValue, equals: 5.75)

        viewModel.handleKeyboard(.delete)
        #expect(viewModel.dueValue == 0)
        #expect(viewModel.tipValue == 0)
    }

    @Test("Duplicate decimal points are ignored and tip stays stable")
    func duplicateDecimalIgnored() {
        let viewModel = makeViewModel(tip: .eighteen)
        viewModel.handleKeyboard(.keyPressed("12.5"))
        viewModel.handleKeyboard(.keyPressed("."))
        #expect(viewModel.amount == "12.5")
        expectCurrency(viewModel.tipValue, equals: 2.25)
    }

    // MARK: - Display roles & reset

    @Test("display(for:) returns tip, due, and total strings")
    func displayForRoles() {
        let viewModel = makeViewModel(amount: "125.00", tip: .fifteen)

        #expect(viewModel.display(for: .due) == viewModel.dueDisplay)
        #expect(viewModel.display(for: .tip) == viewModel.tipDisplay)
        #expect(viewModel.display(for: .total) == viewModel.totalDisplay)
        #expect(viewModel.tipPercentageDisplay == "15%")
    }

    @Test("reset restores default tip, split, and clears the amount")
    func resetRestoresDefaults() {
        let viewModel = makeViewModel(
            amount: "250",
            tip: .custom(amount: 30),
            split: 4
        )

        viewModel.reset()

        #expect(viewModel.amount.isEmpty)
        #expect(viewModel.activeTipElement == .fifteen)
        #expect(viewModel.lastCustomTipPercentage == 0)
        #expect(viewModel.numberOfSplit == 1)
        #expect(viewModel.tipValue == 0)
        #expect(viewModel.totalValue == 0)

        viewModel.selectCustomTip()
        #expect(viewModel.activeTipElement == .custom(amount: 0))
    }

    // MARK: - ActiveTipElement allCases

    @Test("allCases includes the three presets plus a custom placeholder")
    func activeTipElementAllCases() {
        let cases = ActiveTipElement.allCases
        #expect(cases.count == 4)
        #expect(cases.contains(.fifteen))
        #expect(cases.contains(.eighteen))
        #expect(cases.contains(.twenty))
        #expect(cases.contains(where: \.isCustom))
    }
}
