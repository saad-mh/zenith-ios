//
//  UpdateTransactionSheet.swift
//  Zenith
//
//  Created by Mohammed Saad on 12/04/25.
//


import SwiftUI

struct UpdateTransactionSheet: View {
	@Environment(\.dismiss) private var dismiss
	@Bindable var transaction: Transaction
	@State private var selectedCategory: TransactionCategory?
	@State private var transactionAmount: String = ""
	
	var body: some View {
		NavigationStack {
			Form {
				Section(header: Text("Transaction Details")) {
					TextField("Title", text: $transaction.title)
					
					DatePicker("Date", selection: $transaction.date, displayedComponents: .date)
					
					TextField("Amount", text: $transactionAmount)
						.keyboardType(.decimalPad)
						.onChange(of: transactionAmount) { oldValue, newValue in
							if let amount = Double(newValue) {
								transaction.amount = amount
							}
						}
						.onAppear {
							transactionAmount = "\(transaction.amount)"
						}
				}
				
				Section(header: Text("Category")) {
					let categories = TransactionCategory.allCategories

					Picker("Category", selection: $selectedCategory) {
						ForEach(categories, id: \.self) { category in
							Text(category.name).tag(category as TransactionCategory?)
						}
					}
					.onAppear {
						selectedCategory = transaction.category
					}
					.onChange(of: selectedCategory) { oldCategory, newCategory in
						if let newCategory = newCategory {
							transaction.category = newCategory
						}
					}
				}
			}
			.navigationTitle("Edit Transaction")
			.navigationBarTitleDisplayMode(.large)
			.toolbar {
				ToolbarItemGroup(placement: .topBarLeading) {
					Button("Cancel") { dismiss() }
				}
				ToolbarItemGroup(placement: .topBarTrailing) {
					Button("Done") {
						dismiss()
					}
					.disabled(transaction.title.isEmpty || transactionAmount.isEmpty)
				}
			}
		}
	}
}
