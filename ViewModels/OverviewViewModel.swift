//
//  OverviewViewModel.swift
//  Zenith
//
//  Created by Mohammed Saad on 12/04/25.
//


import Foundation

class OverviewViewModel: ObservableObject {
    @Published var transactions: [Transaction] = [] // Transactions passed from the view

    var currentMonthTransactions: [Transaction] {
        let calendar = Calendar.current
        return transactions
            .filter {
                calendar.isDate($0.date, equalTo: Date(), toGranularity: .month)
            }
    }

    var totalExpenses: Double {
        currentMonthTransactions
            .filter { $0.type == .expense }
            .map { $0.amount }
            .reduce(0, +)
    }

    var totalIncomes: Double {
        currentMonthTransactions
            .filter { $0.type == .income }
            .map { $0.amount }
            .reduce(0, +)
    }

    var netBalance: Double {
        totalIncomes - totalExpenses
    }

    var mostSpentCategory: String {
        let expenseCategories = currentMonthTransactions
            .filter { $0.type == .expense }

        let grouped = Dictionary(grouping: expenseCategories, by: { $0.category.name })
        let sorted = grouped.mapValues { $0.reduce(0) { $0 + $1.amount } }
            .sorted { $0.value > $1.value }

        return sorted.first?.key ?? "None"
    }
}
