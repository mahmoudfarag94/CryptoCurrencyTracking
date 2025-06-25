//
//  ErrorView.swift
//  Cryptify
//
//  Created by Jan Babák on 12.12.2022.
//

import SwiftUI
import SwiftUI

struct ErrorView: View {
    let heading: String
    let tryAgainAction: (() async -> Void)?
    private let imageWidth: CGFloat = 272
    private let showTryAgainButton: Bool
    
    
    init(
        heading: String = NSLocalizedString("defaultErrorHeading", comment: "Error heading."),
        tryAgainAction: (() async -> Void)? = nil
    ) {
        self.heading = heading
        self.showTryAgainButton = tryAgainAction != nil
        self.tryAgainAction = tryAgainAction
        
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            errorImage
            errorHeading
            if showTryAgainButton {
                tryAgainButton
            }
        }
        .multilineTextAlignment(.center)
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: - Components
    
    @ViewBuilder
    private var errorImage: some View {
        Image("error")
            .resizable()
            .scaledToFit()
            .frame(width: imageWidth)
            .padding(.bottom, 16)
    }
    
    private var errorHeading: some View {
        Text(heading)
            .font(.headline)
            .fontWeight(.bold)
    }
    
    private var tryAgainButton: some View {
        Button {
            retry()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "arrow.clockwise")
                    .font(.headline)
                Text(NSLocalizedString("Try Again", comment: "Retry action button"))
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding()
            .background(Capsule().fill(Color.theme.accent.opacity(0.2)))
        }
    }
    
    private func retry() {
        guard let action = tryAgainAction else { return }
        Task {
            await action()
        }
    }
}

#Preview {
    ErrorView(heading: "something went wrong")  {
        
    }
}
