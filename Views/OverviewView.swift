//
//  OverviewView.swift
//  Zenith
//
//  Created by Mohammed Saad on 12/04/25.
//


import SwiftUI
import SwiftData

struct OverviewView: View {
    @Query(sort: \Transaction.date, order: .reverse) private var allTransactions: [Transaction]
    @StateObject private var viewModel = OverviewViewModel()
    @State private var selectedTransaction: Transaction?
    @State private var isEditSheetPresented = false
    @State private var searchQuery: String = ""
    @State private var isSearching: Bool = false
    @State private var showFooter: Bool = false // Track footer visibility

    var body: some View {
        ZStack {
            NavigationStack {
                ScrollViewReader { scrollViewProxy in
                    List {
                        // Net Balance Card
                        Section {
                            HStack {
                                VStack(alignment: .center, spacing: 8) {
                                    Text("Net Balance")
                                        .font(.headline)
                                    Text("\(viewModel.netBalance, format: .currency(code: "USD"))")
                                        .font(.largeTitle.bold())
                                    HStack {
                                        Text("Income: \(viewModel.totalIncomes, format: .currency(code: "USD"))")
                                        Text("Expense: \(viewModel.totalExpenses, format: .currency(code: "USD"))")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    Text("Highest expense category: \(viewModel.mostSpentCategory)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 16).fill(Color.blue.opacity(0)))
                                .frame(maxWidth: .infinity)
                            }
//                            .listRowInsets(EdgeInsets()) // Remove default List padding
                        }

                        // Transactions List Grouped by Date
                        ForEach(filteredGroupedTransactions, id: \.key) { date, transactions in
                            Section(header: Text(date, style: .date)) {
                                ForEach(transactions, id: \.id) { transaction in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(transaction.title)
                                                .font(.subheadline)
                                            Text(transaction.date, format: .dateTime.hour().minute())
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }

                                        Spacer()

                                        Text("\(transaction.amount, format: .currency(code: "USD"))")
                                            .foregroundColor(transaction.type == .income ? .green : .red)
                                    }
                                    .padding(.vertical, 4)
                                    .onTapGesture {
                                        selectedTransaction = transaction
                                        isEditSheetPresented = true
                                    }
                                }
                                .onDelete { offsets in
                                    deleteTransaction(at: offsets, in: transactions)
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle()) // Apply InsetGroupedListStyle
                }
				.scrollIndicators(.hidden)
                .sheet(isPresented: $isEditSheetPresented) {
                    if let selectedTransaction {
                        UpdateTransactionSheet(transaction: selectedTransaction)
                    }
                }
                .onAppear {
                    viewModel.transactions = allTransactions
                }
                .navigationTitle("Overview")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            withAnimation {
                                isSearching.toggle()
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
            }

            // Custom Search Overlay
            if isSearching {
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search", text: $searchQuery)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        Button(action: {
                            withAnimation {
                                isSearching = false
                                searchQuery = ""
                            }
                        }) {
                            Text("Cancel")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .background(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

                    Spacer()
                }
            }
        }
    }

    private var filteredGroupedTransactions: [(key: Date, value: [Transaction])] {
        let filteredTransactions = searchQuery.isEmpty
            ? viewModel.currentMonthTransactions
            : viewModel.currentMonthTransactions.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) }

        return Dictionary(grouping: filteredTransactions) { transaction in
            Calendar.current.startOfDay(for: transaction.date)
        }
        .sorted { $0.key > $1.key }
    }

    private func deleteTransaction(at offsets: IndexSet, in transactions: [Transaction]) {
        for index in offsets {
            let transactionToDelete = transactions[index]
            if let indexInAllTransactions = viewModel.transactions.firstIndex(where: { $0.id == transactionToDelete.id }) {
                viewModel.transactions.remove(at: indexInAllTransactions)
            }
        }
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
		let foodCategory = TransactionCategory(name: "Food", type: .expense)
		let jobCategory = TransactionCategory(name: "Job", type: .income)
		let entertainmentCategory = TransactionCategory(name: "Entertainment", type: .expense)
		let freelanceCategory = TransactionCategory(name: "Side Hustle", type: .income)
		let housingCategory = TransactionCategory(name: "Housing", type: .income)
        let mockViewModel = OverviewViewModel()
        mockViewModel.transactions = [
			Transaction(title: "Groceries", amount: 150, date: Date(), category: foodCategory),
				Transaction(title: "Salary", amount: 2000, date: Date(), category: jobCategory),
				Transaction(title: "Netflix", amount: 15, date: Date(), category: entertainmentCategory),
				Transaction(title: "Freelance", amount: 500, date: Date(), category: freelanceCategory),
				Transaction(title: "Rent", amount: 800, date: Date(), category: housingCategory)]

        return OverviewView()
            .environmentObject(mockViewModel)
    }
}
