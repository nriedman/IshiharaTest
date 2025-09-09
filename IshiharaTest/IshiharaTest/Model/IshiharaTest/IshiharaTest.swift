//
//  IshiharaTest.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 5/31/25.
//

import Foundation
import SVG2Path


@Observable
class IshiharaTest {
    private let svgParser = SVG2Path()
    
    let testType: IshiharaTestType
    var selectionChoices: [String] { testType.guessChoices }
    
    var title: String { testType.name }
    
    private var plateChoices: [IshiharaPlateDescription]
    private var plateDeck: [IshiharaPlate]
    
    var currentPlate: IshiharaPlate {
        plateDeck[numPlatesComplete]
    }
    
    var isOver = false
    var isStarted = false
    
    private var alreadyAttempted = false
    
    let numPlates: Int
    var numPlatesComplete: Int = 0
    
    let timeLimitPerPlate: Duration
    var timeRemaining: Duration?
    var plateTimer = Timer.publish(every: PlateTimer.countdownInterval, on: .main, in: .common).autoconnect()
    
    private var submissions: [IshiharaTestAnswer] = []
    
    var curElapsedTime: Duration = .seconds(0)
    
    var didAdvancePlates = false
    
    var score: Int {
        submissions.reduce(0) { $0 + $1.score }
    }
    
    
    init(
        type: IshiharaTestType = DefaultParams.testType,
        length: Int = DefaultParams.testLength,
        timeLimitPerPlate: Duration = DefaultParams.plateTimeLimit
    ) {
        self.testType = type
        self.plateChoices = testType.plates
        
        self.numPlates = length
        self.timeLimitPerPlate = timeLimitPerPlate
        self.timeRemaining = nil
        
        self.plateDeck = []
        self.selectPresentationOrder()
    }
    
    private func selectPresentationOrder() {
        for _ in 0..<numPlates {
            let nextPlateDescription: IshiharaPlateDescription = plateChoices.randomElement() ?? .unknown
            plateDeck.append(IshiharaPlate(descriptor: nextPlateDescription))
        }
    }
    
    
    func startTest() {
        isStarted = true
    }
    
    
    func startTimer() {
        plateTimer.upstream.connect().cancel()
        plateTimer = Timer.publish(every: PlateTimer.countdownInterval, on: .main, in: .common).autoconnect()
        timeRemaining = timeLimitPerPlate - curElapsedTime
        curElapsedTime = .seconds(0)
    }
    
    func pauseTimer() {
        plateTimer.upstream.connect().cancel()
        
        if let timeRemaining {
            curElapsedTime = timeLimitPerPlate - timeRemaining
        }
        
        timeRemaining = nil
    }
    
    func decrementTimeRemaining() {
        if let timeRemaining {
            self.timeRemaining = timeRemaining - .seconds(PlateTimer.countdownInterval)
        }
        
        if let timeRemaining, timeRemaining <= PlateTimer.endTime {
            skipPlate()
        }
    }
    
    
    func skipPlate() {
        advancePlates(score: .incorrect)
    }
    
    
    func attemptGuess(_ guess: String) {
        if (guess == currentPlate.answer) {
            advancePlates(score: alreadyAttempted ? .incorrect : .correct)
        } else {
            alreadyAttempted = true
        }
    }
    
    func advancePlates(score: IshiharaTestAnswer.Score) {
        alreadyAttempted = false
        pauseTimer()
        
        currentPlate.elapsedTime = curElapsedTime
        curElapsedTime = .seconds(0)
        
        submissions.append(
            IshiharaTestAnswer(
                score: score,
                correctPlateDigit: currentPlate.answer,
                responseTime: currentPlate.elapsedTime
            )
        )
        
        if numPlatesComplete + 1 >= numPlates {
            isOver.toggle()
            return
        }
        
        didAdvancePlates = true
        numPlatesComplete += 1
    }
    
    
    func initializePlates() async throws {
        // Load the plates in from disk and generate the dots of each plate.
        for plate in plateDeck {
            try await plate.initialize()
        }
    }
    
    
    func gatherResults() -> TestResultEntry {
        TestResultEntry(
            testName: title,
            timestamp: .now,
            timeLimitPerPlate: timeLimitPerPlate,
            submissions: submissions
        )
    }
    
    
    // MARK: Constants
    struct DefaultParams {
        static let testType: IshiharaTestType = .redGreen
        static let testLength: Int = 10
        static let plateTimeLimitSeconds: TimeInterval = 5
        static let plateTimeLimit: Duration = .seconds(DefaultParams.plateTimeLimitSeconds)
    }
    
    struct ParamLimits {
        static let minTestLength: Int = 3
        static let maxTestLength: Int = 15
        
        static let minPlateTimeLimit: TimeInterval = 3
        static let maxPlateTimeLimit: TimeInterval = 15
    }
    
    struct PlateTimer {
        static let countdownInterval: Double = 0.1
        static let endTime: Duration = .seconds(1e-8)
    }
}


extension IshiharaTest: Identifiable, Equatable {
    static func ==(rhs: IshiharaTest, lhs: IshiharaTest) -> Bool {
        return rhs.id == lhs.id
    }
}
