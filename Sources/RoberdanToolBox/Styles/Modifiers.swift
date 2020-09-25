//
//  Modifiers.swift
//  MirrorableHR
//
//  Created by Roberto D’Angelo on 25/09/2020.
//

import Foundation
import SwiftUI

extension View {
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        
        clipShape( RoundedCorner(radius: radius, corners: corners))
    }
}

public struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
