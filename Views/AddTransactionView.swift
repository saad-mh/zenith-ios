//
//  AddTransactionView.swift
//  Zenith
//
//  Created by Mohammed Saad on 12/04/25.
//

import SwiftUI
import Foundation
import SwiftUICore
import SwiftData


struct AddTransactionView: View {
	@Environment(\.modelContext) var modelContext
	@State private var viewModel = TransactionFormViewModel()
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("Type")) {
					Picker("Transaction Type", selection: $viewModel.selectedType) {
						ForEach(TransactionType.allCases, id: \.self) { type in
							Text(type.displayName).tag(type)
						}
					}
					.pickerStyle(SegmentedPickerStyle())
				}

				Section(header: Text("Category")) {
					Picker("Category", selection: $viewModel.selectedCategory) {
						ForEach(viewModel.filteredCategories, id: \.id) { category in
							Text(category.name).tag(category as TransactionCategory?)
						}
					}
				}

				Section(header: Text("Details")) {
					TextField("Title", text: $viewModel.title)
					TextField("Amount", text: $viewModel.amount)
						.keyboardType(.decimalPad)
					DatePicker("Date", selection: $viewModel.selectedDate, displayedComponents: .date)
					TextField("Note (optional)", text: $viewModel.note)
				}
			}
			.onAppear {
				do {
					let categories = try modelContext.fetch(FetchDescriptor<TransactionCategory>())
					if categories.isEmpty {
						let defaultCategories: [TransactionCategory] = [
							TransactionCategory(name: "Food", type: .expense),
							TransactionCategory(name: "Transport", type: .expense),
							TransactionCategory(name: "Salary", type: .income),
							TransactionCategory(name: "Freelance", type: .income)
						]
						for category in defaultCategories {
							modelContext.insert(category)
						}
						try modelContext.save()
						viewModel.allCategories = defaultCategories
					} else {
						viewModel.allCategories = categories
					}
				} catch {
					print("Failed to fetch or insert categories: \(error)")
				}
			}
			.navigationTitle("Add Expense")
			.navigationBarTitleDisplayMode(.large)
			.toolbar {
				ToolbarItemGroup(placement: .topBarLeading) {
					Button("Cancel") { dismiss() }
				}
				ToolbarItemGroup(placement: .topBarTrailing) {
					Button("Add Transaction") {
						viewModel.createTransaction(modelContext: modelContext)
						dismiss()
					}
					.disabled(!viewModel.isFormValid)
				}
			}
		}
	}
}
