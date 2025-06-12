//
//  TimerView.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/7/25.
//

import SwiftUI


struct TimerView: View {
    // MARK: Data In
    let timeRemaining: TimeInterval?
    let elapsedTime: TimeInterval
    
    // MARK: Data Owned by Me
    private var format: SystemFormatStyle.DateOffset {
        .offset(
            to: .now - timeRemaining! + elapsedTime - TimerParams.endTimeOffset,
            allowedFields: [.minute, .second]
        )
    }
    
    // MARK: - Body
    var body: some View {
        if timeRemaining != nil {
            Text(TimeDataSource<Date>.currentDate, format: format)
        } else {
            Image(systemName: "pause")
                .transition(.opacity)
        }
    }
    
    // MARK: Constants
    struct TimerParams {
        static let endTimeOffset: TimeInterval = 1 - IshiharaTest.PlateTimer.countdownInterval
    }
}

#Preview(traits: .swfitData) {
    TimerView(timeRemaining: 5.0, elapsedTime: 0.0)
}
