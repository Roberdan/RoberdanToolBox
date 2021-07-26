//
//  File.swift
//  
//
//  Created by Roberto D’Angelo on 26/07/21.
//

import Foundation
import SwiftUI

extension DispatchQueue {
    public static func background(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}
