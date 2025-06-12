//
//  SettingsView.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/4/25.
//

import SwiftUI


struct SettingsView: View {
    // MARK: Data In
    @AppStorage(AppSettingsKeys.testLength.rawValue)
    private var testLength: Int = IshiharaTest.DefaultParams.testLength
    
    @AppStorage(AppSettingsKeys.timeLimit.rawValue)
    private var timeLimit: TimeInterval = IshiharaTest.DefaultParams.plateTimeLimitSeconds
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                Section("Ishihara Test") {
                    Picker("**Number of Plates**", selection: $testLength) {
                        ForEach(IshiharaTest.ParamLimits.minTestLength...IshiharaTest.ParamLimits.maxTestLength, id: \.self) { length in
                            Text(length, format: .number)
                        }
                    }
                    
                    HStack {
                        Stepper(
                            "**Time Limit**",
                            value: $timeLimit,
                            in: IshiharaTest.ParamLimits.minPlateTimeLimit...IshiharaTest.ParamLimits.maxPlateTimeLimit,
                            step: 1
                        )
                        Text(timeLimit, format: .number)
                    }
                }
                
                Button("Reset to Default", role: .destructive) {
                    resetSettings()
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    func resetSettings() {
        testLength = IshiharaTest.DefaultParams.testLength
        timeLimit = IshiharaTest.DefaultParams.plateTimeLimitSeconds
    }
}


#Preview(traits: .swfitData) {
    @Previewable @State var showSheet: Bool = false
    
    NavigationStack {
        Button("Show Sheet") {
            showSheet.toggle()
        }
            .sheet(isPresented: $showSheet) {
                SettingsView()
            }
    }
}
