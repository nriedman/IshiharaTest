//
//  AggregateScoreChart.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/11/25.
//

import Charts
import SwiftUI

struct AggregateScoreChart: View {
    struct AggregateScore {
        let anchorDate: Date
        let averageScore: Double
        let minScore: Double
        let maxScore: Double
        let numConstituents: Int
    }
    
    // MARK: Data In
    let rawData: [TestResultEntry]
    
    // MARK: Data Owned by Me
    @State private var aggregatedData: [AggregateScore] = []
    
    var dateLowerBound: Date {
        let lowestDate = aggregatedData.min(by: { $0.anchorDate < $1.anchorDate })?.anchorDate ?? .distantPast
        let oneWeekFromNow: Date = Calendar.current.startOfDay(for: .now).addingTimeInterval(-60 * 60 * 24 * 7)
        return max(lowestDate.addingTimeInterval(-60 * 60 * 24), oneWeekFromNow) // One day buffer.
    }
    var dateUpperBound: Date {
        let highestDate = aggregatedData.max(by: { $0.anchorDate < $1.anchorDate })?.anchorDate ?? .distantFuture
        let oneWeekFromNow: Date = Calendar.current.startOfDay(for: .now).addingTimeInterval(60 * 60 * 24 * 7)
        return min(highestDate.addingTimeInterval(60 * 60 * 24 * 2), oneWeekFromNow) // One day buffer.
    }
    
    // MARK: Init
    init(data: [TestResultEntry]) {
        rawData = data
    }
    
    // MARK: - Body
    var body: some View {
        Group {
            if aggregatedData.isEmpty {
                ProgressView("Aggregating Data...")
            } else {
                ///
                /// Attribution:
                ///
                /// This chart was styled following these tutorials:
                ///     https://developer.apple.com/videos/play/wwdc2022/10137/
                ///     https://developer.apple.com/documentation/charts/customizing-axes-in-swift-charts
                ///
                Chart(aggregatedData.indices, id: \.self) { idx in
                    let dataPoint = aggregatedData[idx]
                    BarMark(
                        x: .value("Day", dataPoint.anchorDate, unit: .day),
                        yStart: .value("Score Min", dataPoint.minScore * 100),
                        yEnd: .value("Score Max", dataPoint.maxScore * 100),
                        width: ChartStyle.scoreMarkWidth
                    )
                    .opacity(ChartStyle.minMaxRangeOpacity)
                    RectangleMark(
                        x: .value("Day", dataPoint.anchorDate, unit: .day),
                        y: .value("Daily Average", dataPoint.averageScore * 100),
                        width: ChartStyle.scoreMarkWidth,
                        height: ChartStyle.scoreMarkHeight
                    )
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day))
                }
                .chartXScale(domain: dateLowerBound...dateUpperBound)
                .chartYAxis {
                    AxisMarks(
                        format: Decimal.FormatStyle.Percent.percent.scale(1),
                        values: [0, 50, 100]
                    )
                }
                .chartYScale(domain: 0...100)
            }
        }
        .onChange(of: rawData, initial: true) {
            Task {
                aggregatedData = await aggregateData(rawData)
            }
        }
    }
    
    func aggregateData(_ data: [TestResultEntry]) async -> [AggregateScore] {
        let dataGroupedByDay = Dictionary<Date, [TestResultEntry]>.init(grouping: data, by: { entry in
            Calendar.current.startOfDay(for: entry.timestamp)
        })
        
        var results: [AggregateScore] = []
        
        for (anchorDay, entries) in dataGroupedByDay {
            let percentageScores: [Double] = entries.map { entry in
                Double(entry.score) / Double(entry.testLength)
            }
            let percentageScoresAvg = percentageScores.reduce(0.0) { $0 + $1 } / Double(percentageScores.count)
            
            let newDataPoint = AggregateScore(
                anchorDate: anchorDay,
                averageScore: percentageScoresAvg,
                minScore: percentageScores.min() ?? 0,
                maxScore: percentageScores.max() ?? 0,
                numConstituents: entries.count
            )
            
            results.append(newDataPoint)
        }
        
        return results.sorted(by: { $0.anchorDate < $1.anchorDate })
    }
    
    // MARK: Constants
    struct ChartStyle {
        static let minMaxRangeOpacity: CGFloat = 0.3
        static let scoreMarkWidth: MarkDimension = .ratio(0.6)
        static let scoreMarkHeight: MarkDimension = 2
    }
}

#Preview {
    AggregateScoreChart(data: [])
}
