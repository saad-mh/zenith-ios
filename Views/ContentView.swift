//
//  ContentView.swift
//  Zenith
//
//  Created by Mohammed Saad on 11/04/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .overview
    @State private var isAddSheetPresented = false
    @State private var keyboardHeight: CGFloat = 0 // Track keyboard height

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                OverviewView()
                    .tabItem {
                        Label("Overview", systemImage: "house")
                    }
                    .tag(Tab.overview)

                InsightsView()
                    .tabItem {
                        Label("Insights", systemImage: "chart.bar")
                    }
                    .tag(Tab.insights)
				Spacer()
                BudgetsView()
                    .tabItem {
                        Label("Budgets", systemImage: "target")
                    }
                    .tag(Tab.budgets)

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .tag(Tab.settings)
            }

            // Add Transaction Button
            if keyboardHeight == 0 {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isAddSheetPresented = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                            }
                            .padding(.horizontal, 35)
                            .padding(.vertical, 12)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(radius: 3)
                        }
                        .accessibilityLabel("Add Transaction")
                        Spacer()
                    }
                    .padding(.bottom, 8) // Fixed padding at the bottom
                }
            }
        }
        .sheet(isPresented: $isAddSheetPresented, onDismiss: {
            selectedTab = .overview
        }) {
            AddTransactionView()
        }
        .onAppear {
            observeKeyboardNotifications()
        }
        .onDisappear {
            removeKeyboardNotifications()
        }
    }

    // Observe keyboard notifications
    private func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardFrame.height
            }
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            keyboardHeight = 0
        }
    }

    // Remove keyboard notifications
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

enum Tab: Hashable {
    case overview, insights, budgets, settings, add
}

struct InsightsView: View {
    var body: some View {
        Text("Insights Screen")
    }
}

struct BudgetsView: View {
    var body: some View {
        Text("Budgets & Goals Screen")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings Screen")
    }
}

struct AddButtonView: View {
    var body: some View {
        AddTransactionView()
    }
}

#Preview {
    ContentView()
}
