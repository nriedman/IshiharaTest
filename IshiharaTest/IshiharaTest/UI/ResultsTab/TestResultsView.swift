//
//  TestResultsView.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/7/25.
//

import SwiftData
import SwiftUI


struct TestResultsView: View {
    // MARK: Data Shared with Me
    @Query(sort: \TestResultEntry.timestamp, order: .reverse) private var results: [TestResultEntry]
    
    // MARK: Data Owned by Me
    @State private var resultsDisplayType: ResultsType = .aggregate
    @State private var aggregateTestType: IshiharaTestType = .redGreen
    
    // MARK: - Body
    var body: some View {
        Group {
            if results.isEmpty {
                ContentUnavailableView(
                    "No Results",
                    systemImage: "tray",
                    description: Text("Complete a survey to see results.")
                )
            } else {
                VStack {
                    displayTypePicker()
                    resultsPage(for: resultsDisplayType)
                }
            }
        }
            .navigationTitle("Results")
    }
    
    func displayTypePicker() -> some View {
        Picker("Choose Results", selection: $resultsDisplayType) {
            Text("Combined")
                .tag(ResultsType.aggregate)
            
            Text("All Results")
                .tag(ResultsType.individual)
        }
            .pickerStyle(.segmented)
            .padding(.horizontal)
    }
    
    @ViewBuilder
    func resultsPage(for displayType: ResultsType) -> some View {
        switch displayType {
        case .aggregate: AllTestResultsView(dataPoints: results, testType: $aggregateTestType)
        case .individual: TestResultsList(dataPoints: results)
        }
    }
    
    enum ResultsType: Int {
        case aggregate = 0
        case individual = 1
    }
}

#Preview(traits: .swfitData) {
    TestResultsView()
}
