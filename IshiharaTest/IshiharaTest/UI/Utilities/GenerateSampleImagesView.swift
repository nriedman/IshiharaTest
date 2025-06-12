//
//  GenerateSampleImagesView.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/8/25.
//

import SwiftUI
import UIKit

///
/// Attribution:
///
/// This view was composed with with help from the following tutorial:
///     https://www.hackingwithswift.com/quick-start/swiftui/how-to-convert-a-swiftui-view-to-an-image
///
struct GenerateSampleImagesView: View {
    @Environment(\.displayScale) private var displayScale
    
    let plate: IshiharaPlate
    let testName: String
    
    var body: some View {
        Button("Render sample plate") {
            Task {
                do {
                    try await plate.initialize()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
            .onChange(of: plate.isInitializing) {
                if !plate.isInitializing {
                    render()
                }
            }
    }
    
    
    @MainActor func render() {
        let renderer = ImageRenderer(content: IshiharaPlateView(plate: plate))
        renderer.scale = displayScale
        
        let filename = testName
        
        if let uiImage = renderer.uiImage,
           let data = uiImage.pngData() {
            let url = URL(filePath: "/Users/nickriedman/Desktop/IshiharaTestSamples/\(filename).png", directoryHint: .notDirectory)
            try? data.write(to: url)
        }
    }
}
