//
//  AggregateResultsSummary.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/11/25.
//

import SwiftUI

struct AggregateResultsSummary: View {
    // MARK: Data In
    let dataPoints: [TestResultEntry]
    
    // MARK: Data Owned by Me
    var allTimeAvgResponseTime: Duration {
        let allResponseTimes = dataPoints.flatMap(\.submittedAnswers).map(\.responseTime)
        return allResponseTimes.map({ $0 }).reduce(.seconds(0), +) / Double(allResponseTimes.count)
    }
    var allTimeAvgScore: Double {
        let allScores = dataPoints.map { Double($0.score) / Double($0.testLength) }
        return Double(allScores.reduce(0, +)) / Double(allScores.count)
    }
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }

    // MARK: Init
    init(dataPoints: [TestResultEntry]) {
        self.dataPoints = dataPoints
    }
    
    // MARK: - Body
    var body: some View {
        LazyVStack(spacing: SectionList.verticalSpacing) {
            Section {
                AggregateScoreChart(data: dataPoints)
                    .frame(minHeight: SectionList.minSectionHeight)
            } header: {
                sectionHeader(title: "Score") {
                    Text("All Time Average: \(numberFormatter.string(for: allTimeAvgScore) ?? "0.0")")
                }
            }
            
            Section {
                AggregateResponseTimeChart(dataPoints: dataPoints)
                    .frame(minHeight: SectionList.minSectionHeight)
            } header: {
                sectionHeader(title: "Response Time") {
                    Text("All Time Average: \(allTimeAvgResponseTime.formatted(Duration.UnitsFormatStyle.ishiharaTestTimeDuration))")
                }
            }
        }
    }
    
    func sectionHeader<SubHeaderContent: View>(
        title: String,
        subHeaderContent: @escaping () -> SubHeaderContent = { EmptyView() }
    ) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title2)
                    .bold()
                subHeaderContent()
            }
            Spacer()
        }
    }
    
    // MARK: Constants
    struct SectionList {
        static let verticalSpacing: CGFloat = 32
        static let minSectionHeight: CGFloat = 150
    }
}


#Preview(traits: .swfitData) {
    AggregateResultsSummary(dataPoints: [])
}
