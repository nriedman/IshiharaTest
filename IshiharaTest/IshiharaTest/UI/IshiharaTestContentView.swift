//
//  IshiharaTestContentView.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/4/25.
//

import SwiftUI


enum IshiharaTestTabs: Int {
    case home = 0
    case results = 1
    case settings = 2
}


struct IshiharaTestContentView: View {
    // MARK: Data In
    ///
    /// Attribution:
    ///
    /// This use of `@AppStorage` was informed by the following tutorial:
    ///     https://www.hackingwithswift.com/books/ios-swiftui/storing-user-settings-with-userdefaults
    ///
    @AppStorage("tabSelection") private var tabSelection: IshiharaTestTabs = .home
    
    // MARK: Data Owned by Me
    @State private var showSettings = false
    
    // MARK: - Body
    var body: some View {
        TabView(selection: $tabSelection) {
            Tab("Home", systemImage: "house", value: IshiharaTestTabs.home) {
                NavigationStack {
                    IshiharaTestHomeView()
                        .toolbar {
                            settingsButton()
                        }
                }
            }
            
            Tab("Results", systemImage: "tray.full", value: IshiharaTestTabs.results) {
                NavigationStack {
                    TestResultsView()
                        .toolbar {
                            settingsButton()
                        }
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    func settingsButton() -> some View {
        Button("Settings", systemImage: "gear") {
            showSettings.toggle()
        }
    }
}


#Preview(traits: .swfitData) {
    IshiharaTestContentView()
}
