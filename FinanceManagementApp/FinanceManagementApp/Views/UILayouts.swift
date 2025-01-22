//
//  UILayouts.swift
//  FinanceManagementApp
//
//  Created by 指原奈々 on 2025/01/22.
//

import Foundation
import SwiftUI

struct TitleLabelStyle: ViewModifier {
    func body(content:Content) -> some View {
        content
            .bold()
            .font(.system(size: 20))
    }
}

extension View {
    func titleLabel() -> some View {
        self.modifier(TitleLabelStyle())
    }
}
