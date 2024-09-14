//
//  View+Extension.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/14/24.
//

import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ value: Bool) -> some View {
        if value { hidden() }
        else { self }
    }
}
