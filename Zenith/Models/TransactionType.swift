//
//  TransactionType.swift
//  Zenith
//
//  Created by Mohammed Saad on 12/04/25.
//

enum TransactionType: String, Codable, CaseIterable {
	case income
	case expense
	
	var displayName: String {
		switch self {
			case .income: return "Income"
			case .expense: return "Expense"
		}
	}
}
