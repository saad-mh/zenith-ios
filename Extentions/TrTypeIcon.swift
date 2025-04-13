//
//  TrTypeIcon.swift
//  Zenith
//
//  Created by Mohammed Saad on 12/04/25.
//

extension TransactionType {
	var icon: String {
		switch self {
		case .income: return "arrow.down.circle.fill"
		case .expense: return "arrow.up.circle.fill"
		}
	}
}
