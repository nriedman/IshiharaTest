//
//  IshiharaTestHomeView.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/4/25.
//

import SwiftUI

struct IshiharaTestHomeView: View {
    // MARK: Data In
    @AppStorage(AppSettingsKeys.testLength.rawValue)
    private var testLength: Int = IshiharaTest.DefaultParams.testLength
    
    @AppStorage(AppSettingsKeys.timeLimit.rawValue)
    private var timeLimitSeconds: TimeInterval = IshiharaTest.DefaultParams.plateTimeLimitSeconds
    
    // MARK: Data Owned By Me
    @State private var activeTest: IshiharaTest?
    
    // MARK: - Body
    var body: some View {
        List {
            ForEach(IshiharaTestType.allCases, id: \.self) { testType in
                Button {
                    activeTest = IshiharaTest(
                        type: testType,
                        length: testLength,
                        timeLimitPerPlate: .seconds(timeLimitSeconds)
                    )
                } label: {
                    IshiharaTestCard(testType: testType)
                }
            }
        }
        .navigationTitle("Surveys")
        .listStyle(.plain)
        .sheet(item: $activeTest) { test in
            IshiharaTestSheetView(test: test)
        }
    }
}

#Preview(traits: .swfitData) {
    IshiharaTestHomeView()
}
