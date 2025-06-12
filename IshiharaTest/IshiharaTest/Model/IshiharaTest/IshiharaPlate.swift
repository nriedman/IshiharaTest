//
//  Plate.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/3/25.
//

import Foundation
import SwiftUICore
import SVG2Path


@Observable
class IshiharaPlate: Identifiable {
    static let unknown = IshiharaPlate(descriptor: .init(filename: "", correctSymbol: "", inRegionColorCodes: [], outRegionColorCodes: []))
    private static let svgParser = SVG2Path()
    
    let answer: String
    
    var interiorColorCodes: [String] = ["#FF0000"]
    var exteriorColorCodes: [String] = ["#00FF00"]
    
    let symbolFileName: String
    var path: Path = Path()
    var dots: [Dot] = []
    
    var elapsedTime: Duration = .seconds(0)
    
    var isInitializing = true
    
    
    init(descriptor: IshiharaPlateDescription) {
        self.interiorColorCodes = descriptor.inRegionColorCodes
        self.exteriorColorCodes = descriptor.outRegionColorCodes
        
        self.answer = descriptor.correctSymbol
        self.symbolFileName = descriptor.filename
    }
    
    
    func initialize() async throws {
        self.isInitializing = true
        
        print("Loading path from: \(symbolFileName).svg")
        try await self.loadSymbolPath()
        
        print("Generating dots for symbol: \(answer)")
        await self.generateDots()
        
        self.isInitializing = false
    }
    
    func loadSymbolPath() async throws {
        guard !symbolFileName.isEmpty else {
            return
        }
        
        // Make sure the plate exists.
        guard let plateURL = Bundle.main.url(forResource: symbolFileName, withExtension: "svg") else {
            throw IshiharaError.fileNotFound(file: symbolFileName)
        }
        
        // Load in its contents as a string.
        let plateSVGString = try String(contentsOf: plateURL, encoding: .utf8)
        
        // Parse the stringn tot a path using SVG2Path
        guard let platePathData = IshiharaPlate.svgParser.extractPath(text: plateSVGString) else {
            throw IshiharaError.invalidSVGString
        }
        
        // Convert the path data to a Path.
        guard let platePath = convertPathDataToPath(platePathData) else {
            throw IshiharaError.invalidSVGPath
        }
        
        // Normalize the coordinates of the Path.
        let boundingRect = platePath.boundingRect
        
        let longSideLength = max(boundingRect.width, boundingRect.height)
        let scale = 1.0 / longSideLength
        
        let transform = CGAffineTransform(scaleX: scale, y: scale)
            .translatedBy(x: -boundingRect.minX, y: -boundingRect.minY)
        
        let normalizedPath = platePath.applying(transform)
        
        self.path = normalizedPath
    }
    
    //
    // NOTE:
    //  I made sure to design the SVGs to only have one path here,
    //  so for now I only take the first path in the paths returned.
    //
    //  As an extension, flesh out this function to handle more complicated
    //  svgs with multiple path components.
    //
    private func convertPathDataToPath(_ pathData: SVGPathData) -> Path? {
        return pathData.paths.first
    }
    
    
    func attemptToAddANewDot() async {
        // To make this algorithm slightly more efficient, use radial coords
        // to choose candidate points so that we can guarantee the point
        // will be within the circle at least.
        let theta = Double.random(in: 0...2 * .pi)
        let r = Double.random(in: 0...0.5 - DotGenParams.minDotRadius)
        
        let pnt = CGPoint(x: 0.5 + r * cos(theta), y: 0.5 + r * sin(theta))

        // If an existing dot is too close to the point, skip it and try another one.
        if dots.contains(where: {
            $0.contains(
                pnt,
                padding: DotGenParams.minDotRadius + DotGenParams.minDotSpacing
            )
        }) {
            return
        }
    
        // Otherwise, we assign the dot a random radius without overlapping the nearest dot.
        let nearestDot = dots.min(by: {
            $0.center.distance(to: pnt) < $1.center.distance(to: pnt)
        }) ?? Dot(
            center: .init(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.greatestFiniteMagnitude),
            radius: .zero
        )
        
        let distFromCircleCenter = pnt.distance(to: .init(x: 0.5, y: 0.5))
        let distToEdge = abs(distFromCircleCenter - 0.5)

        let distPntToNearestPaddedSurface = pnt.distance(to: nearestDot.center) - (nearestDot.radius + DotGenParams.minDotSpacing)
        let upperBoundRadius = max(
            min(
                distToEdge,
                min(distPntToNearestPaddedSurface, DotGenParams.maxDotRadius)
            ),
            DotGenParams.minDotRadius
        )

        let newDot = Dot(
            center: pnt,
            radius: .random(in: DotGenParams.minDotRadius...upperBoundRadius)
        )

        dots.append(newDot)
    }
    
    
    func generateDots(_ n: Int = DotGenParams.defaultDotCount) async {
        dots.removeAll()
        var attempts = 0
        
        while dots.count < n {
            await attemptToAddANewDot()
            attempts += 1
            
            if attempts >= n * DotGenParams.dotSaturationMultiplier {
                break
            }
        }
    }
    
    
    func getScaledSymbol(in rect: CGRect, padding: CGFloat) -> Path {
        let plateRadius = min(rect.width, rect.height) / 2
        let innerSquareWidth = 2 * plateRadius / sqrt(2)
        
        let xInset = (rect.width - innerSquareWidth) / 2 + padding
        let yInset = (rect.height - innerSquareWidth) / 2 + padding
        let scaledBound = rect.insetBy(dx: xInset, dy: yInset)
        
        let symbolBoundary = path
            .scaleToFit(in: scaledBound)
            .centered(in: rect)
        
        return symbolBoundary
    }
    
    
    struct Dot: Identifiable {
        var id = UUID()
        
        let center: CGPoint
        let radius: CGFloat
        
        
        // Returns true if the given `CGPoint` is contained in the dot's
        // circle extended by a given padding.
        func contains(_ pt: CGPoint, padding: CGFloat = 0) -> Bool {
            return pt.distance(to: center) < radius + padding
        }
        
        func scaled(to rect: CGRect) -> Dot {
            let scaleFactor = min(rect.width, rect.height)
            let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            
            let scaledDot = Dot(
                center: center.applying(scaleTransform),
                radius: radius * scaleFactor
            )
            
            return scaledDot
        }
    }
    
    struct DotGenParams {
        static let minDotSpacing: CGFloat = 0.0075
        
        static let minDotRadius: CGFloat = 0.010
        static let maxDotRadius: CGFloat = 0.040
        
        static let defaultDotCount: Int = 1000
        static let dotSaturationMultiplier: Int = 100
    }
}


extension CGPoint {
    func distance(to pnt: CGPoint) -> Double {
        return sqrt(pow((x - pnt.x), 2) + pow((y - pnt.y), 2))
    }
}
