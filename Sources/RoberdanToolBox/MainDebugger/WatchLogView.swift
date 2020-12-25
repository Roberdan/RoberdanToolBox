//
//  WatchLog.swift
//  it shows logs from MainDebugger.shared on Apple Watch
//
//  Created by Roberto D’Angelo on 22/12/20.
//

import Foundation
import SwiftUI

@available(iOS 14.0, macOS 11, watchOS 7.0, *)
public struct WatchLogView: View {
    @ObservedObject var myDebugger: MainDebugger = MainDebugger.shared
   
    public init() {}

    public var body: some View {
        return List(myDebugger.debugLogs.reversed(), id: \.self) { logs in
            LogsRow(logs: logs)
        }
    }
}

@available(iOS 14.0, macOS 11, watchOS 7.0, *)
public struct LogsRow: View {
    var logs: DebugLog

    public var body: some View {
        HStack {
            Text("\(logs.debugTimeStamp.toTimeStampFormatter())")
            Text("\(logs.debugString)")
        }
    }
}
