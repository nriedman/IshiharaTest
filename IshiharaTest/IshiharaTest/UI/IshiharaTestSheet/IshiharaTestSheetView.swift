//
//  ContentView.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 5/31/25.
//

import SwiftUI
import SVG2Path


struct IshiharaTestSheetView: View {
    // MARK: Data In
    @Environment(\.dismiss) private var dismiss
    let test: IshiharaTest
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            if !test.isStarted {
                IshiharaTestOnboardingView(for: test)
                    .transition(.move(edge: .leading))
            } else if test.isOver {
                IshiharaTestResultsSummary(test: test)
                    .transition(.opacity)
            } else {
                IshiharaTestView(test: test)
                    .transition(.opacity)
            }
        }
        .padding()
        .animation(.ishiharaTest, value: test.numPlatesComplete)
        .task {
            do {
                try await test.initializePlates()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview(traits: .swfitData) {
    IshiharaTestSheetView(test: IshiharaTest())
}
