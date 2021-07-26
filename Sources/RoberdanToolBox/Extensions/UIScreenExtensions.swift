//
//  File.swift
//  
//
//  Created by Roberto D’Angelo on 26/07/21.
//

import Foundation
import SwiftUI

#if os(iOS)
@available(iOS 13.0, *)
extension UIScreen {
    public static let screenWidth = UIScreen.main.bounds.size.width
    public static let screenHeight = UIScreen.main.bounds.size.height
    public static let screenSize = UIScreen.main.bounds.size

    public static func setBrightness(to: CGFloat) {
        UIScreen.main.brightness = to
    }
}
#endif
