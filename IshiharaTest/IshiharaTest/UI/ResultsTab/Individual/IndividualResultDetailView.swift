//
//  IndividualResultDetailView.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/9/25.
//

import Charts
import SwiftUI

struct IndividualResultDetailView: View {
    // MARK: Data In
    let dataPoint: TestResultEntry
    
    // MARK: Data Owned by Me
    var totalTime: Duration {
        dataPoint.submittedAnswers.reduce(.seconds(0)) { $0 + $1.responseTime }
    }
    var averageResponseTime: Duration {
        totalTime / Double(dataPoint.testLength)
    }
    
    // MARK: - Body
    var body: some View {
        List {
            Section("Survey Information") {
                surveyInfoSection()
            }
            
            Section("Score") {
                VStack(spacing: ScoreCard.verticalSpacing) {
                    Gauge(value: Double(dataPoint.score), in: 0...Double(dataPoint.testLength)) {
                        Text("\(dataPoint.score) / \(dataPoint.testLength)")
                            .font(.headline)
                    }
                    scoreCollage()
                }
                .padding(.vertical)
            }
            
            Section("Response Time") {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Average:")
                            .bold()
                        Text(averageResponseTime.formatted(Duration.UnitsFormatStyle.ishiharaTestTimeDuration))
                    }
                    responseTimeChart()
                        .frame(maxHeight: StatisticStack.maxComponentHeight)
                }
                .padding(.vertical)
            }
        }
        .headerProminence(.increased)
    }
    
    
    func scoreCollage() -> some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(dataPoint.submittedAnswers.indices, id: \.self) { idx in
                    let submission = dataPoint.submittedAnswers[idx]
                    GroupBox("Digit: \(submission.correctPlateDigit)") {
                        Text(submission.score == 0 ? "Incorrect" : "Correct")
                        Text("\(submission.responseTime.formatted(Duration.UnitsFormatStyle.ishiharaTestTimeDuration))")
                    }
                }
            }
        }
    }
    
    func surveyInfoSection() -> some View {
        VStack(alignment: .leading, spacing: StatisticStack.verticalSpacing) {
            HStack {
                Text("Survey Type")
                    .bold()
                Spacer()
                Text(dataPoint.testName)
            }
            HStack {
                Text("Length")
                    .bold()
                Spacer()
                Text(dataPoint.testLength, format: .number)
            }
            HStack {
                Text("Taken")
                    .bold()
                Spacer()
                Text(dataPoint.timestamp.formatted(date: .abbreviated, time: .omitted))
            }
            HStack {
                Text("Total Time")
                    .bold()
                Spacer()
                Text(totalTime.formatted(Duration.UnitsFormatStyle.ishiharaTestTimeDuration))
            }
        }
    }
    
    
    func responseTimeChart() -> some View {
        Chart {
            ForEach(Array(dataPoint.submittedAnswers.enumerated()), id: \.offset) { index, submission in
                BarMark(x: .value("Plate", index + 1), y: .value("Time", submission.responseTime.toTimeInterval()))
            }
            RuleMark(y: .value("TimeLimit", dataPoint.timeLimitPerPlate.toTimeInterval()))
                .lineStyle(
                    .init(
                        lineWidth: ResponseTimeChart.timeLimitLineWidth,
                        dash: ResponseTimeChart.timeLimitDashConfig
                    )
                )
                .annotation(position: .top, alignment: .leading) {
                    Text("Time Limit")
                        .font(.caption)
                        .foregroundStyle(ResponseTimeChart.timeLimitAnnotationColor)
                }
                .foregroundStyle(ResponseTimeChart.timeLimitAnnotationColor)
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: dataPoint.testLength))
        }
        .chartXScale(domain: 0...dataPoint.testLength + 1)
    }
    
    // MARK: Constants
    struct StatisticStack {
        static let verticalSpacing: CGFloat = 12
        static let maxComponentHeight: CGFloat = 150
    }
    
    struct ResponseTimeChart {
        static let timeLimitLineWidth: CGFloat = 2
        static let timeLimitDashConfig: [CGFloat] = [5]
        static let timeLimitAnnotationColor: Color = .red
    }
    
    struct ScoreCard {
        static let verticalSpacing: CGFloat = 12
    }
}

#Preview(traits: .swfitData) {
    NavigationStack {
        IndividualResultDetailView(dataPoint: .mockExample)
    }
}
