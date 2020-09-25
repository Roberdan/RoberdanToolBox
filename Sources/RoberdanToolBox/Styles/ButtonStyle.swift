//
//  ButtonStyle.swift
//  MirrorableHR
//
//  Created by Roberto D’Angelo on 25/09/2020.
//

import Foundation
import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public struct SquishableButtonStyle: ButtonStyle {
    var fadeOnPress = true
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed && fadeOnPress ? 0.75 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
