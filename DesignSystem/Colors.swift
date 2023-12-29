//
//  Colors.swift
//  DesignSystem
//
//  Created by Stan Sidel on 29.12.2023.
//

import SwiftUI

private let bundleId = "com.plussios.DesignSystem"

extension Color {
    public struct Widget {
        public static let background = Color("WidgetColors/Background", bundle: Bundle(identifier: bundleId))
        public static let text = Color("WidgetColors/Text", bundle: Bundle(identifier: bundleId))
    }
}
