//
//  DebuggingTools.swift
//  MirrorableHR
//
//  Created by Roberto D’Angelo on 25/09/2020.
//

import Foundation

//MARK: PrintToConsole - use it instead than print as it runs only in debug mode and not on release
public func printToConsole(_ message : Any) {
    #if DEBUG
        print(String(describing: message))
    #endif
}
