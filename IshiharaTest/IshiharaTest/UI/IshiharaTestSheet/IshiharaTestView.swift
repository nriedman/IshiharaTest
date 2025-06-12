//
//  IshiharaTestView.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/3/25.
//

import SwiftUI

struct IshiharaTestView: View {
    // MARK: Data In
    @Environment(\.dismiss) private var dismiss
    let test: IshiharaTest
    
    // MARK: Init
    init(test: IshiharaTest) {
        self.test = test
    }
    
    // MARK: - Body
    var body: some View {
        if test.currentPlate.isInitializing {
            ProgressView("Loading plate...")
                .transition(.opacity)
        } else {
            VStack {
                IshiharaPlateView(plate: test.currentPlate)
                
                Spacer()
                
                SymbolSelectionView(choices: test.selectionChoices) { selection in
                    withAnimation(.ishiharaTest) {
                        test.attemptGuess(selection)
                    } completion: {
                        if test.didAdvancePlates {
                            restartTimer()
                        }
                    }
                }
            }
            .navigationTitle("\(test.numPlatesComplete + 1) of \(test.numPlates)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    TimerView(timeRemaining: test.timeRemaining?.toTimeInterval(), elapsedTime: test.curElapsedTime.toTimeInterval())
                }
            }
            .transition(.opacity)
            .onReceive(test.plateTimer) { _ in
                withAnimation(.none) {
                    test.decrementTimeRemaining()
                } completion: {
                    if test.didAdvancePlates {
                        restartTimer()
                    }
                }
            }
            .trackElapsedTime(of: test)
        }
    }
    
    func restartTimer() {
        withAnimation {
            test.startTimer()
            test.didAdvancePlates = false
        }
    }
}

// TODO: Make a good preview system for this.
#Preview(traits: .swfitData) {
    NavigationStack {
        IshiharaTestView(test: IshiharaTest(type: .redGreen))
    }
}
