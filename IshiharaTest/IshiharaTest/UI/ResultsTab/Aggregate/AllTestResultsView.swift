//
//  AllTestResultsView.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/9/25.
//

import SwiftUI

struct AllTestResultsView: View {
    // MARK: Data In
    let dataPoints: [TestResultEntry]
    
    // MARK: Data Shared with Me
    @Binding var testType: IshiharaTestType
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            LazyVStack {
                HStack {
                    Spacer()
                    Picker("Survey Type", selection: $testType.animation(.ishiharaTest)) {
                        ForEach(IshiharaTestType.allCases, id: \.self) { testTypeOption in
                            Text(testTypeOption.name)
                        }
                    }
                }
                
                aggregateSummary(for: testType)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func aggregateSummary(for type: IshiharaTestType) -> some View {
        let data = dataPoints.filter { $0.testName == type.name }
        if data.isEmpty {
            ContentUnavailableView("No Results", systemImage: "tray")
        } else {
            AggregateResultsSummary(dataPoints: data)
        }
    }
}

#Preview(traits: .swfitData) {
    AllTestResultsView(dataPoints: [], testType: .constant(.blueYellow))
}
