//
//  CalculationViewModel.swift
//  Tipie
//
//  Created by Neftali Samarey on 7/27/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class CalculationViewModel {

    /// Raw digits entered by the user for the amount due.
    var amount: String = ""

    /// Currently selected tip preset. Updating this keeps `tipPercentage` in sync.
    var activeTipElement: ActiveTipElement = .fifteen

    /// Number of people the bill is split across. Never drops below 1.
    var numberOfSplit: Int = 1

    /// Tip percentage applied to the amount due. Defaults to the `.fifteen` preset.
    var tipPercentage: Double {
        activeTipElement.percentage
    }

    // MARK: Calculated values

    /// The amount the user entered, parsed into a number.
    var dueValue: Double {
        Double(amount) ?? 0
    }

    /// The tip, calculated behind the scenes from the due amount and percentage.
    var tipValue: Double {
        dueValue * tipPercentage / 100
    }

    /// The grand total the user owes.
    var totalValue: Double {
        dueValue + tipValue
    }

    // MARK: Display strings

    var dueDisplay: String { format(dueValue) }
    var tipDisplay: String { format(tipValue) }
    var totalDisplay: String { format(totalValue) }

    /// The active tip percentage formatted for display (in string format), e.g. "15%".
    var tipPercentageDisplay: String {
        "\(Int(tipPercentage.rounded()))%"
    }

    /// The total bill split evenly across `numberOfSplit` people, formatted as
    /// currency. The divisor is floored at 1 to avoid dividing by zero.
    var perPersonDisplay: String {
        format(totalValue / Double(max(numberOfSplit, 1)))
    }

    /// Formatted currency string for a given display role.
    func display(for role: RoleType) -> String {
        switch role {
        case .due: return dueDisplay
        case .tip: return tipDisplay
        case .total: return totalDisplay
        }
    }

    // MARK: Input handling

    func handleKeyboard(_ action: KeyboardView.Action) {
        switch action {
        case .keyPressed(let value):
            append(value)

        case .delete:
            delete()
        }
    }

    private func append(_ value: String) {
        if value == "." && amount.contains(".") {
            return
        }

        amount.append(value)
    }

    private func delete() {
        guard amount.isEmpty == false else { return }
        amount.removeLast()
    }

    private func format(_ value: Double) -> String {
        value.formatted(
            .currency(code: Locale.current.currency?.identifier ?? "USD")
        )
    }
    
    // rset the cumulator
    func reset() {
        amount = ""
        activeTipElement = .fifteen
        numberOfSplit = 1
    }
}
