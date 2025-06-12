//
//  TestResultsList.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/8/25.
//

import SwiftUI


struct TestResultsList: View {
    // MARK: Data In
    @Environment(\.modelContext) private var modelContext
    let dataPoints: [TestResultEntry]
    
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                ForEach(dataPoints) { dataPoint in
                    NavigationLink {
                        IndividualResultDetailView(dataPoint: dataPoint)
                    } label: {
                        HStack(spacing: ResultCard.horizontalSpacing) {
                            Gauge(value: Double(dataPoint.score), in: 0...Double(dataPoint.testLength)) {
                                Text(dataPoint.score, format: .number)
                            }
                            .gaugeStyle(.accessoryCircularCapacity)
                            .frame(maxWidth: ResultCard.maxGaugeWidth)
                            VStack(alignment: .leading) {
                                Text(dataPoint.testName)
                                    .font(.headline)
                                Text(dataPoint.timestamp, format: .dateTime)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteData)
            }
            .listStyle(.plain)
        }
    }
    
    func deleteData(indices: IndexSet) {
        for idx in indices {
            modelContext.delete(dataPoints[idx])
        }
    }
    
    // MARK: Constants
    struct ResultCard {
        static let horizontalSpacing: CGFloat = 8
        static let verticalSpacing: CGFloat = 12
        static let maxGaugeWidth: CGFloat = 100
    }
}

#Preview(traits: .swfitData) {
    TestResultsList(dataPoints: [])
}
