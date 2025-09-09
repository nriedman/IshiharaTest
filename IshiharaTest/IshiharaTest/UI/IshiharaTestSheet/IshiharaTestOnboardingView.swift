//
//  IshiharaTestOnboardingView.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/8/25.
//

import SwiftUI

struct IshiharaTestOnboardingView: View {
    // MARK: Data In
    @Environment(\.dismiss) private var dismiss
    let test: IshiharaTest
    
    // MARK: Init
    init(for test: IshiharaTest) {
        self.test = test
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: TestDescription.verticalSpacing) {
                    
                    /// Attribution:
                    ///
                    /// The text of the onboarding description was created with the help of the AI overview provided
                    /// by Google in response to the following query:
                    ///     "ishihara test description"
                    ///
                    Text("The following test will consist of a series of plates featuring a single digit between 0 and 9. Individuals without color vision deficiency can often identify each digit, while those with color vision deficiency may see it differently or not at all.")
                    
                    Text("This test is timed, and will have the following constraints:")
                }
                Spacer()
            }
            
            VStack {
                HStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxWidth: ListBullets.maxWidth)
                    Text("Time limit")
                        .bold()
                    Text(test.timeLimitPerPlate.formatted(Duration.UnitsFormatStyle.ishiharaTestTimeDuration))
                    
                    Spacer()
                }
                .offset(x: ListBullets.minIndent, y: 0)
                HStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxWidth: ListBullets.maxWidth)
                    Text("Number of Plates")
                        .bold()
                    Text(test.numPlates, format: .number)
                    
                    Spacer()
                }
                .offset(x: ListBullets.minIndent, y: 0)
            }
            
            Spacer()
            
            Button("Start Survey") {
                withAnimation {
                    test.startTest()
                }
            }
            .buttonStyle(.borderedProminent)
            .font(.headline)
        }
        .padding()
        .navigationTitle("Ishihara Test")
        .toolbar {
            Button("Cancel") {
                dismiss()
            }
        }
    }
    
    // MARK: Constants
    struct TestDescription {
        static let verticalSpacing: CGFloat = 12
    }
    
    struct ListBullets {
        static let maxWidth: CGFloat = 10
        static let minIndent: CGFloat = 32
    }
}

#Preview(traits: .swfitData) {
    @Previewable @State var showSheet = false
    Button("Show Sheet") {
        showSheet.toggle()
    }
    .sheet(isPresented: $showSheet) {
        NavigationStack {
            IshiharaTestOnboardingView(for: IshiharaTest())
        }
    }
}
