//
//  ExtractedView.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/3/25.
//

import Foundation
import SwiftUI


struct IshiharaPlateView: View {
    // MARK: Data In
    let plate: IshiharaPlate
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            let outerBound = geometry.frame(in: .local)
            let symbolOutline = plate.getScaledSymbol(in: outerBound, padding: PlateFrame.symbolPadding)
            
            ZStack {
                Circle()
                    .fill(.clear)
                    .position(x: outerBound.midX, y: outerBound.midY)
                
                ForEach(plate.dots) { dot in
                    let scaledDot = dot.scaled(to: outerBound)
                    
                    let scaledDotX = scaledDot.center.x
                    let scaledDotY = scaledDot.center.y
                    
                    Circle()
                        .position(
                            x: scaledDot.radius + scaledDotX - outerBound.width / 2,
                            y: scaledDotY
                        )
                        .frame(width: scaledDot.radius * 2)
                        .foregroundStyle(
                            symbolOutline.contains(scaledDot.center)
                            ? Color(hex: plate.interiorColorCodes.randomElement() ?? "#C1440E")
                            : Color(hex: plate.exteriorColorCodes.randomElement() ?? "#6B8E23")
                        )
                }

            }
        }
        .frame(
            minWidth: PlateFrame.minRadius,
            maxWidth: PlateFrame.maxRadius,
            minHeight: PlateFrame.minRadius,
            maxHeight: PlateFrame.maxRadius
        )
        .aspectRatio(1.0, contentMode: .fit)
    }
    
    // MARK: - Constants
    struct PlateFrame {
        static let shape = Circle()
        
        // NOTE:
        //  In the future, I'd like to make this more dynamic
        //  and possibly depend on the size of the screen.
        //
        //  However, that poses its own problems, and for now
        //  I've tested it on iOS, iPad, and macOS, and all three
        //  look fine with this being the biggest radius allowed.
        //
        static let minRadius: CGFloat = 200
        static let maxRadius: CGFloat = 600
        
        static let symbolPadding: CGFloat = 10
    }
}


#Preview(traits: .swfitData) {
    IshiharaPlateView(plate: IshiharaPlate(descriptor: IshiharaPlateDescription(filename: "0", correctSymbol: "0", inRegionColorCodes: [], outRegionColorCodes: [])))
}
