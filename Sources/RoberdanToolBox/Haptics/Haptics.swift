//
//  Haptics.swift
//
//  Created by Roman Luzgin on 27.06.21.
//

import Foundation
import SwiftUI

public struct Haptics {
    public static func giveHaptic() {
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
           
    }
    
    public static func giveSmallHaptic() {
        let impactMed = UIImpactFeedbackGenerator(style: .light)
            impactMed.impactOccurred()
           
    }
    
    public static func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    

}

