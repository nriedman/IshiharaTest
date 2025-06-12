//
//  IshiharaTestCard.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/8/25.
//

import SwiftUI

struct IshiharaTestCard: View {
    // MARK: Data In
    let testType: IshiharaTestType
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: CardStyle.horizontalSpacing) {
            Image(testType.name)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: CardStyle.sampleImageMaxSize)
            
            VStack(alignment: .leading, spacing: CardStyle.verticalSpacing) {
                Text(testType.name)
                    .font(.headline)
                Text("Targets:")
                    .font(.subheadline)
                    .italic()
                Text(testType.targets)
                    .font(.subheadline)
            }
            
            Spacer()
        }
    }
    
    // MARK: Constants
    struct CardStyle {
        static let horizontalSpacing: CGFloat = 12
        static let verticalSpacing: CGFloat = 4
        static let sampleImageMaxSize: CGFloat = 100
    }
}

#Preview(traits: .swfitData) {
    IshiharaTestCard(testType: .redGreen)
}
