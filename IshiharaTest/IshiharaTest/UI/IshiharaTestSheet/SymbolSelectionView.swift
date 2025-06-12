//
//  SymbolSelectionView.swift
//  IshiharaTest
//
//  Created by Nick Riedman on 6/4/25.
//

import SwiftUI

struct SymbolSelectionView<LeadingAuxilliaryView, TrailingAuxilliaryView>: View where LeadingAuxilliaryView: View, TrailingAuxilliaryView: View {
    // MARK: Data In
    let choices: [String]
    
    // MARK: Data Out Function
    let onSelection: ((String) -> Void)?
    
    // MARK: Data In Function
    let leadingAuxilliaryView: () -> LeadingAuxilliaryView
    let trailingAuxilliaryView: () -> TrailingAuxilliaryView
    
    // MARK: Init
    init(
        choices: [String],
        onSelection: ((String) -> Void)? = nil,
        leadingAuxilliaryView: @escaping () -> LeadingAuxilliaryView = { EmptyView() },
        trailingAuxilliaryView: @escaping () -> TrailingAuxilliaryView = { EmptyView() }
    ) {
        self.choices = choices
        self.onSelection = onSelection
        self.leadingAuxilliaryView = leadingAuxilliaryView
        self.trailingAuxilliaryView = trailingAuxilliaryView
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            HStack {
                keyPadRow(including: 1..<4)
            }
            HStack {
                keyPadRow(including: 4..<7)
            }
            HStack {
                keyPadRow(including: 7..<10)
            }
            HStack {
                leadingAuxilliaryView()
                keyPadRow(including: 0..<1)
                
            }
        }
            .aspectRatio(6 / 7, contentMode: .fit)
    }
    
    
    func keyPadRow(including indexRange: Range<Int>) -> some View {
        ForEach(indexRange, id: \.self) { idx in
            selectionKey(for: choices[idx])
                .padding(.horizontal, KeyPad.keySpacing)
        }
    }
    
    func selectionKey(for choice: String) -> some View {
        Button {
            onSelection?(choice)
        } label: {
            Circle()
                .stroke()
                .overlay {
                    Text(choice)
                        .font(.title)
                }
        }
    }
}

// MARK: Constants
fileprivate struct KeyPad {
    static let keySpacing: CGFloat = 5
}

#Preview(traits: .swfitData) {
    SymbolSelectionView(choices: "0123456789".map { String($0) })
}
