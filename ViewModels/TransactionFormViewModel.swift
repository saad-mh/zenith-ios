//
//  TransactionFormViewModel.swift
//  Zenith
//
//  Created by Mohammed Saad on 12/04/25.
//

import Foundation
import SwiftData


@Observable
class TransactionFormViewModel {
    var title: String = ""
    var amount: String = ""
    var selectedDate: Date = .now
    var selectedType: TransactionType = .expense
    var selectedCategory: TransactionCategory?

    var note: String = ""

    var allCategories: [TransactionCategory] = [] // Injected or fetched on init

	var filteredCategories: [TransactionCategory] {
        allCategories.filter { $0.type == selectedType }
    }

    var isFormValid: Bool {
        !title.isEmpty && Double(amount) != nil && selectedCategory != nil
    }

    func createTransaction(modelContext: ModelContext) {
        guard let amount = Double(amount), let category = selectedCategory else { return }

        let transaction = Transaction(
            title: title,
            amount: amount,
            date: selectedDate,
            category: category,
            note: note.isEmpty ? nil : note
        )

        modelContext.insert(transaction)
    }
}
