//
//  ZenithApp.swift
//  Zenith
//
//  Created by Mohammed Saad on 11/04/25.
//

import SwiftUI
import SwiftData

@main
struct ZenithApp: App {
    init() {
        TransactionCategory.initializeDefaultCategories()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
				.modelContainer(for: [Transaction.self])
                .environmentObject(OverviewViewModel())
        }
    }
}
