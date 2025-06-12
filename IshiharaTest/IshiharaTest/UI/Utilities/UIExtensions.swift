//
//  UIExtensions.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/3/25.
//

import SwiftUI


// MARK: Time tracking

struct TrackElapsedTime: ViewModifier {
    // MARK: Data In
    @Environment(\.scenePhase) private var scenePhase
    let test: IshiharaTest
    
    // MARK: - Body
    func body(content: Content) -> some View {
        content
            .onChange(of: test) { oldTest, newTest in
                oldTest.pauseTimer()
                newTest.startTimer()
            }
            .onChange(of: scenePhase) { _, newPhase in
                switch newPhase {
                case .active: test.startTimer()
                case .inactive: test.pauseTimer()
                default: break
                }
            }
            .onAppear {
                test.startTimer()
            }
            .onDisappear {
                test.pauseTimer()
            }
    }
}


extension View {
    func trackElapsedTime(of test: IshiharaTest) -> some View {
        self.modifier(TrackElapsedTime(test: test))
    }
}


// MARK: Path extensions

extension Path {
    func scaleToFit(in rect: CGRect) -> Path {
        // NOTE:
        //  Doesn't account for translating origin.
        //
        //  Make sure that boundingRect is normalized to be of size 1 on the long side
        //  and with origin (0, 0).
        //
        let xScale = rect.width / boundingRect.width
        let yScale = rect.height / boundingRect.height
        let scale = min(xScale, yScale)
        
        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        return applying(scaleTransform)
    }
    
    func centered(in rect: CGRect) -> Path {
        // NOTE:
        //  Doesn't account for scaling.
        //
        //  Make sure that boundingRect is normalized to the same units as rect.
        //
        let xShift = -(boundingRect.midX - rect.midX)
        let yShift = -(boundingRect.midY - rect.midY)
        
        let translationTransform = CGAffineTransform(translationX: xShift, y: yShift)
        return applying(translationTransform)
    }
}


// MARK: Animation extensions

extension Animation {
    static let ishiharaTest: Animation = .easeInOut
}


// MARK: Color extensions

//
// Attribution:
//
//  This extension was written with the help of ChatGPT.
//
//  Prompt:
//      Actually, print the hex codes in a format that will be easy to put into a Swift array.
//
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: FormatStyle extensions

extension Duration.UnitsFormatStyle {
    static let ishiharaTestTimeDuration: Self = .units(fractionalPart: .show(length: 2))
}
