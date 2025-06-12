//
//  IshiharaTestType.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/4/25.
//

import Foundation


struct IshiharaPlateDescription {
    static let unknown: IshiharaPlateDescription = .init(filename: "", correctSymbol: "", inRegionColorCodes: [], outRegionColorCodes: [])
    
    let filename: String
    let correctSymbol: String
    
    let inRegionColorCodes: [String]
    let outRegionColorCodes: [String]
}


enum IshiharaTestType: CaseIterable {
    case redGreen
    case blueYellow
    case monochromatic
    
    var name: String {
        switch self {
        case .redGreen: "Red-Green"
        case .blueYellow: "Blue-Yellow"
        case .monochromatic: "Monochromatic"
        }
    }
    
    var targets: String {
        switch self {
        case .redGreen: "Deuteranomaly, Protanomaly, Protanopia, Deuteranopia"
        case .blueYellow: "Tritanomaly, Tritanopia"
        case .monochromatic: "Monochromacy / Achromatopsia"
        }
    }
    
    var plates: [IshiharaPlateDescription] {
        switch self {
        default: [
            IshiharaPlateDescription(
                filename: "0",
                correctSymbol: "0",
                inRegionColorCodes: self.inRegionColorCodes,
                outRegionColorCodes: self.outRegionColorCodes
            ),
            IshiharaPlateDescription(
                filename: "1",
                correctSymbol: "1",
                inRegionColorCodes: self.inRegionColorCodes,
                outRegionColorCodes: self.outRegionColorCodes
            ),
            IshiharaPlateDescription(
                filename: "2",
                correctSymbol: "2",
                inRegionColorCodes: self.inRegionColorCodes,
                outRegionColorCodes: self.outRegionColorCodes
            ),
            IshiharaPlateDescription(
                filename: "3",
                correctSymbol: "3",
                inRegionColorCodes: self.inRegionColorCodes,
                outRegionColorCodes: self.outRegionColorCodes
            ),
            IshiharaPlateDescription(
                filename: "4",
                correctSymbol: "4",
                inRegionColorCodes: self.inRegionColorCodes,
                outRegionColorCodes: self.outRegionColorCodes
            ),
            IshiharaPlateDescription(
                filename: "5",
                correctSymbol: "5",
                inRegionColorCodes: self.inRegionColorCodes,
                outRegionColorCodes: self.outRegionColorCodes
            ),
            IshiharaPlateDescription(
                filename: "6",
                correctSymbol: "6",
                inRegionColorCodes: self.inRegionColorCodes,
                outRegionColorCodes: self.outRegionColorCodes
            ),
            IshiharaPlateDescription(
                filename: "7",
                correctSymbol: "7",
                inRegionColorCodes: self.inRegionColorCodes,
                outRegionColorCodes: self.outRegionColorCodes
            ),
            IshiharaPlateDescription(
                filename: "8",
                correctSymbol: "8",
                inRegionColorCodes: self.inRegionColorCodes,
                outRegionColorCodes: self.outRegionColorCodes
            ),
            IshiharaPlateDescription(
                filename: "9",
                correctSymbol: "9",
                inRegionColorCodes: self.inRegionColorCodes,
                outRegionColorCodes: self.outRegionColorCodes
            ),
        ]
        }
    }
    
    var guessChoices: [String] {
        switch self {
        default: "0123456789".map { String($0) }
        }
    }
    
    //
    // Attribution:
    //
    //  These hex codes were assembled with the help of ChatGPT.
    //
    //  Prompt:
    //      Please give me hex codes for a variety of red colors that will do well in an Ishihara test.
    //      Do the same for green, yellow, and blue.
    //
    var inRegionColorCodes: [String] {
        switch self {
        case .redGreen: [
            "#C1440E",          // Reds
            "#E2725B",
            "#CD5C5C",
            "#65000B",
            "#FA8072",
            "#C75B39"
        ]
        case .blueYellow: [
            "#4F81C7",          // Blues
            "#5DADEC",
            "#1E3A5F",
            "#7DAFD6",
            "#6C7B8B",
            "#3B6AA0"
        ]
        case .monochromatic: [
            "#C1440E",          // Reds
            "#E2725B",
            "#CD5C5C",
            "#65000B",
            "#FA8072",
            "#C75B39",
            "#6B8E23",          // Greens
            "#8A9A5B",
            "#B2AC88",
            "#4F7942",
            "#D0F0C0",
            "#B5B35C"
        ]
        }
    }
    
    var outRegionColorCodes: [String] {
        switch self {
        case .redGreen: [
            "#6B8E23",          // Greens
            "#8A9A5B",
            "#B2AC88",
            "#4F7942",
            "#D0F0C0",
            "#B5B35C"
        ]
        case .blueYellow: [
            "#D4AF37",          // Yellows
            "#F0E68C",
            "#E1C16E",
            "#FFD966",
            "#DCC97A",
            "#FADA5E"
        ]
        case .monochromatic: [
            "#4F81C7",          // Blues
            "#5DADEC",
            "#1E3A5F",
            "#7DAFD6",
            "#6C7B8B",
            "#3B6AA0",
            "#D4AF37",          // Yellows
            "#F0E68C",
            "#E1C16E",
            "#FFD966",
            "#DCC97A",
            "#FADA5E"
        ]
        }
    }
}

