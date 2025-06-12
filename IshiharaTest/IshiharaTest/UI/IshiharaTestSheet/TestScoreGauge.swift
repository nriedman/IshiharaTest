//
//  TestScoreGauge.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/8/25.
//

import SwiftUI


fileprivate extension View {
    func flexibleSystemFont(minimum: CGFloat = 8, maximum: CGFloat = 80) -> some View {
        self
            .font(.system(size: maximum, design: .rounded))
            .minimumScaleFactor(minimum / maximum)
    }
}


///
/// Attribution:
///
/// The following  `IshiharaResultGauge` was based on the tutorial:
///     https://www.appcoda.com/swiftui-gauge/
///
struct IshiharaResultGauge: GaugeStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .foregroundStyle(.gray.opacity(0.1))
            
            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(GaugeParams.borderStyle, lineWidth: GaugeParams.gaugeWidth)
                .rotationEffect(.degrees(135))
            
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(Color.black, style: GaugeParams.lineDashesStyle)
                .rotationEffect(.degrees(135))
            
            VStack {
                configuration.currentValueLabel
                    .flexibleSystemFont(maximum: GaugeParams.currentValFontSize)
                    .bold()
                    .foregroundColor(.gray)
                
                if let maxValLabel = configuration.maximumValueLabel {
                    HStack(alignment: .center) {
                        Text("/")
                        maxValLabel
                    }
                    .flexibleSystemFont(maximum: GaugeParams.maximumValFontSize)
                    .foregroundColor(.gray)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: GaugeParams.maxDiameter)
    }
    
    // MARK: Constants
    struct GaugeParams {
        static let maxDiameter: CGFloat = 300
        static let borderStyle = Color.green
        static let gaugeWidth: CGFloat = 20
        static let lineDashesStyle = StrokeStyle(lineWidth: 10, lineCap: .butt, lineJoin: .round, dash: [1, 34], dashPhase: 0.0)
        
        static let currentValFontSize: CGFloat = 80
        static let maximumValFontSize: CGFloat = 32
    }
}


struct TestScoreGauge: View {
    // MARK: Data In
    let score: Double
    let maxScore: Double
    
    // MARK: - Body
    var body: some View {
        Gauge(value: score, in: 0...maxScore) {
            // No central label
        } currentValueLabel: {
            Text(score, format: .number)
        } minimumValueLabel: {
            // No minimum value label
            Text("")
        } maximumValueLabel: {
            Text(maxScore, format: .number)
        }
        .gaugeStyle(IshiharaResultGauge())
    }
}

#Preview(traits: .swfitData) {
    TestScoreGauge(score: 4, maxScore: 10)
}
