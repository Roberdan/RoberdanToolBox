//
//  WatchLog.swift
//  it shows logs from MainDebugger.shared on Apple Watch
//
//  Created by Roberto D’Angelo on 22/12/20.
//

import Foundation
import SwiftUI

public struct WatchLogView: View {
    @ObservedObject var myDebugger: MainDebugger = MainDebugger.shared
   
    public init() {}

    public var body: some View {
        return List(myDebugger.debugLogs.reversed(), id: \.self) { logs in
            LogsRow(logs: logs)
        }
    }
}

public struct LogsRow: View {
    var logs: DebugLog

    public var body: some View {
        HStack {
            Text("\(logs.debugTimeStamp.toTimeStampFormatter())")
            Text("\(logs.debugString)")
        }
    }
}
