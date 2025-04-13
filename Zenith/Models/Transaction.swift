//
//  Transaction.swift
//  Zenith
//
//  Created by Mohammed Saad on 12/04/25.
//

import Foundation
import SwiftData

@Model
final class Transaction: Identifiable {
	@Attribute(.unique) var id: UUID
	var title: String
	var amount: Double
	var date: Date
	var category: TransactionCategory
	var note: String?
	
	init(title: String, amount: Double, date: Date, category: TransactionCategory, note: String? = nil) {
		self.id = UUID()
		self.title = title
		self.amount = amount
		self.date = date
		self.category = category
		self.note = note
	}
	var type: TransactionType {
		return category.type
	}
}

extension Transaction {
	static func mockData() -> [Transaction] {
		let foodCategory = TransactionCategory(name: "Food", type: .expense)
		let jobCategory = TransactionCategory(name: "Job", type: .income)
		let entertainmentCategory = TransactionCategory(name: "Entertainment", type: .expense)
		let freelanceCategory = TransactionCategory(name: "Side Hustle", type: .income)
		let housingCategory = TransactionCategory(name: "Housing", type: .income)

		return [
			Transaction(title: "Groceries", amount: 150, date: Date(), category: foodCategory),
			Transaction(title: "Salary", amount: 2000, date: Date(), category: jobCategory),
			Transaction(title: "Netflix", amount: 15, date: Date(), category: entertainmentCategory),
			Transaction(title: "Freelance", amount: 500, date: Date(), category: freelanceCategory),
			Transaction(title: "Rent", amount: 800, date: Date(), category: housingCategory)
		]
	}
}
