//
//  TestResultEntry.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/7/25.
//

import Foundation
import SwiftData


struct IshiharaTestAnswer {
    enum Score: Int {
        case correct = 1
        case incorrect = 0
    }
    
    let score: Int
    let correctPlateDigit: String
    let responseTime: Duration
    
    init(score: Score, correctPlateDigit: String, responseTime: Duration) {
        self.score = score.rawValue
        self.correctPlateDigit = correctPlateDigit
        self.responseTime = responseTime
    }
    
    init(score: Int, correctPlateDigit: String, responseTime: Duration) {
        self.score = score
        self.correctPlateDigit = correctPlateDigit
        self.responseTime = responseTime
    }
}


@Model
class TestResultEntry {
    var testName: String
    var timestamp: Date
    
    private var _timeLimitPerPlate: TimeInterval = 0
    var timeLimitPerPlate: Duration {
        get {
            .seconds(_timeLimitPerPlate)
        }
        set {
            _timeLimitPerPlate = newValue.toTimeInterval()
        }
    }
    
    private var _scores: [Int]
    private var _responseTimes: [TimeInterval]
    private var _correctDigits: [String]

    var testLength: Int {
        _scores.count
    }
    
    var score: Int {
        _scores.reduce(0, +)
    }
    
    var submittedAnswers: [IshiharaTestAnswer] {
        var result: [IshiharaTestAnswer] = []
        for idx in _scores.indices {
            result.append(IshiharaTestAnswer(
                score: _scores[idx],
                correctPlateDigit: _correctDigits[idx],
                responseTime: .seconds(_responseTimes[idx])
            ))
        }
        return result
    }
    
    init(
        testName: String,
        timestamp: Date,
        timeLimitPerPlate: Duration,
        submissions: [IshiharaTestAnswer]
    ) {
        self.testName = testName
        self.timestamp = timestamp
        self._timeLimitPerPlate = timeLimitPerPlate.toTimeInterval()
        
        self._scores = submissions.map { $0.score }
        self._correctDigits = submissions.map { $0.correctPlateDigit }
        self._responseTimes = submissions.map { $0.responseTime.toTimeInterval() }
    }
}

extension TestResultEntry {
    static let mockExample: TestResultEntry = TestResultEntry(
        testName: "Red-Green",
        timestamp: .now.addingTimeInterval(-60 * 60 * 12.0), // 12 hours ago
        timeLimitPerPlate: .seconds(5.0),
        submissions: [
            IshiharaTestAnswer(score: .correct, correctPlateDigit: "0", responseTime: .seconds(1.5)),
            IshiharaTestAnswer(score: .incorrect, correctPlateDigit: "4", responseTime: .seconds(1.9)),
            IshiharaTestAnswer(score: .incorrect, correctPlateDigit: "5", responseTime: .seconds(2.0)),
            IshiharaTestAnswer(score: .correct, correctPlateDigit: "2", responseTime: .seconds(2.5)),
            IshiharaTestAnswer(score: .correct, correctPlateDigit: "8", responseTime: .seconds(3.0)),
            IshiharaTestAnswer(score: .correct, correctPlateDigit: "9", responseTime: .seconds(2.8)),
            IshiharaTestAnswer(score: .incorrect, correctPlateDigit: "9", responseTime: .seconds(2.1)),
            IshiharaTestAnswer(score: .correct, correctPlateDigit: "6", responseTime: .seconds(1.3)),
            IshiharaTestAnswer(score: .correct, correctPlateDigit: "7", responseTime: .seconds(0.8)),
            IshiharaTestAnswer(score: .correct, correctPlateDigit: "8", responseTime: .seconds(1.0))
        ]
    )
    
    static func randomExample(numPlates: Int = 10, timeLimit: TimeInterval = 3.0) -> TestResultEntry {
        let randomTimeStamp: Date = .now.addingTimeInterval(-60 * 60 * 6 * .random(in: 0...10))
        
        var subs: [IshiharaTestAnswer] = []
        for _ in 0..<numPlates {
            subs.append(
                IshiharaTestAnswer(
                    score: .random(in: 0...1),
                    correctPlateDigit: "0123456789".map({ String($0) }).randomElement() ?? "0",
                    responseTime: .seconds(.random(in: 0...timeLimit))
                )
            )
        }
        
        return TestResultEntry(
            testName: IshiharaTestType.allCases.randomElement()?.name ?? "Red-Green",
            timestamp: randomTimeStamp,
            timeLimitPerPlate: .seconds(timeLimit),
            submissions: subs
        )
    }
}
