//
//  SwiftDataPreview.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/7/25.
//

import Foundation
import SwiftData
import SwiftUI


struct SwiftDataPreview: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(
            for: TestResultEntry.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)  // Don't use disk space for previews.
        )
        
        let mockDataPoints: [TestResultEntry] = [
            .randomExample(numPlates: 10, timeLimit: 5.0),
            .randomExample(numPlates: 10, timeLimit: 3.0),
            .randomExample(numPlates: 10, timeLimit: 6.0),
            .randomExample(numPlates: 15, timeLimit: 4.0),
            .randomExample(numPlates: 12, timeLimit: 7.0),
            .randomExample(numPlates: 6, timeLimit: 5.0)
        ]
        
        for mockDataPoint in mockDataPoints {
            container.mainContext.insert(mockDataPoint)
        }
        
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}


extension PreviewTrait<Preview.ViewTraits> {
    @MainActor static var swfitData: Self = .modifier(SwiftDataPreview())
}
