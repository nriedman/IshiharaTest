//
//  AggregateResponseTimeChart.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/11/25.
//

import Charts
import SwiftUI

struct AggregateResponseTimeChart: View {
    struct AggregateResponseTime {
        let anchorDigit: String
        let averageResponseTime: TimeInterval
        let minResponseTime: Double?
        let maxResponseTime: Double?
        let numConstituents: Int
    }
    
    // MARK: Data In
    let dataPoints: [TestResultEntry]
    
    // MARK: Data Owned by Me
    @State private var aggregatedData: [AggregateResponseTime] = []
    
    // MARK: - Body
    var body: some View {
        Group {
            if aggregatedData.isEmpty {
                ProgressView("Aggregating response times...")
            } else {
                Chart(aggregatedData.indices, id: \.self) { idx in
                    let dataPoint = aggregatedData[idx]
                    
                    if let min = dataPoint.minResponseTime {
                        BarMark(
                            x: .value("Digit", dataPoint.anchorDigit),
                            y: .value("Daily Min", min)
                        )
                        .foregroundStyle(by: .value("Priority", "Daily Min"))
                    }
                    
                    BarMark(
                        x: .value("Digit", dataPoint.anchorDigit),
                        y: .value("Daily Avg", dataPoint.averageResponseTime)
                    )
                    .foregroundStyle(by: .value("Priority", "Daily Avg"))
                    
                    if let max = dataPoint.maxResponseTime {
                        BarMark(
                            x: .value("Digit", dataPoint.anchorDigit),
                            y: .value("Daily Max", max)
                        )
                        .foregroundStyle(by: .value("Priority", "Daily Max"))
                    }
                }
                .chartXScale(domain: (0...9).map(String.init)) // Make sure all digits show.
                .chartXAxis {
                    AxisMarks(values: (0...9).map(String.init)) { val in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
            }
        }
            .onChange(of: dataPoints, initial: true) {
                Task {
                    aggregatedData = await aggregateData(dataPoints)
                }
            }
    }
    
    func aggregateData(_ data: [TestResultEntry]) async -> [AggregateResponseTime] {
        let allAnswers = data.flatMap(\.submittedAnswers)
        let allDigitResponseTimePairs: [(digit: String, time: TimeInterval)] = allAnswers.map {
            ($0.correctPlateDigit, $0.responseTime.toTimeInterval())
        }
        
        let responseTimesGroupedByDigit = Dictionary(grouping: allDigitResponseTimePairs, by: \.digit)
        
        var results: [AggregateResponseTime] = []
        for (digit, pairs) in responseTimesGroupedByDigit {
            let responseTimes = pairs.map(\.time)
            let averageResponseTime: TimeInterval = responseTimes.reduce(0, +) / Double(responseTimes.count)
            
            let newDataPoint = AggregateResponseTime(
                anchorDigit: digit,
                averageResponseTime: averageResponseTime,
                minResponseTime: responseTimes.min(),
                maxResponseTime: responseTimes.max(),
                numConstituents: responseTimes.count
            )
            
            results.append(newDataPoint)
        }
        
        return results.sorted(by: { $0.anchorDigit < $1.anchorDigit })
    }
}


#Preview(traits: .swfitData) {
    AggregateResponseTimeChart(dataPoints: [])
}
