//
//  Duration+ToTimeInterval.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/11/25.
//

import Foundation


extension Duration {
    func toTimeInterval() -> TimeInterval {
        let seconds = components.seconds
        let attoSeconds = components.attoseconds
        
        return TimeInterval(seconds) + Double(attoSeconds) * 1e-18
    }
}
