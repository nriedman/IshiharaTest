//
//  IshiharaTestResultsSummary.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/4/25.
//

import SwiftUI


struct IshiharaTestResultsSummary: View {
    // MARK: Data In
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let test: IshiharaTest
    
    // MARK: - Body
    var body: some View {
        VStack {
            TestScoreGauge(score: Double(test.score), maxScore: Double(test.numPlates))
        }
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Submit") {
                        let resultEntry = test.gatherResults()
                        modelContext.insert(resultEntry)
                        dismiss()
                    }
                }
            }
    }
}

#Preview(traits: .swfitData) {
    ProgressView()
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                IshiharaTestResultsSummary(test: IshiharaTest())
            }
        }
}
