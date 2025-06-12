//
//  IshiharaError.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/4/25.
//

import Foundation


enum IshiharaError: LocalizedError {
    case fileNotFound(file: String)
    case invalidSVGString
    case invalidSVGPath
}
