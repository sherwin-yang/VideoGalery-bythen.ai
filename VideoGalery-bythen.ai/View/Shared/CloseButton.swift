//
//  CloseButton.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/15/24.
//

import SwiftUI

struct CloseButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button(
            action: { dismiss() },
            label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(Color(UIColor.secondaryLabel))
            }
        )
    }
}

#Preview {
    CloseButton()
}
