//
//  Category.swift
//  Zenith
//
//  Created by Mohammed Saad on 12/04/25.
//

import SwiftData
import Foundation

@Model
final class TransactionCategory {
    @Attribute(.unique) var id: UUID
    var name: String
    var type: TransactionType
    var icon: String?

    // Static array to hold all categories
    private static var categories: [TransactionCategory] = []

    init(name: String, type: TransactionType, icon: String? = "chevron.up.right.2") {
        self.id = UUID()
        self.name = name
        self.type = type
        self.icon = icon

        // Add the new category to the static array
        TransactionCategory.categories.append(self)
    }
}

extension TransactionCategory {
    // Computed property to access all categories
    static var allCategories: [TransactionCategory] {
        return categories
    }

    // Method to initialize default categories
    static func initializeDefaultCategories() {
        if categories.isEmpty { // Ensure this is only done once
            _ = TransactionCategory(name: "Food", type: .expense)
            _ = TransactionCategory(name: "Salary", type: .income)
            _ = TransactionCategory(name: "Entertainment", type: .expense)
            _ = TransactionCategory(name: "Transportation", type: .expense)
			_ = TransactionCategory(name: "Gifts", type: .income)
        }
    }
}
