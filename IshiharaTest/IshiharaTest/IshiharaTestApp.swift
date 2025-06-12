//
//  IshiharaTestApp.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 5/31/25.
//

import SwiftUI

@main
struct IshiharaTestApp: App {
    var body: some Scene {
        WindowGroup {
            IshiharaTestContentView()
                .modelContainer(for: TestResultEntry.self)
        }
    }
}
