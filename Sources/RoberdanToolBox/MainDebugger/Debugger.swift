//
//  MainDebugger.swift
//  Epilepsy Research Kit
//
//  Created by Roberto D’Angelo on 26/04/2020.
//  Copyright © 2020 FightTheStroke Foundation. All rights reserved.
//

import Foundation
import SwiftUI

// TODO: handle errors from the code, like events, errors etc
@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
public enum DebugMsgType: String {
    case error = "Error"
    case event = "Event"
    case notification = "Notification"
    case fatalError = "Fatal Error"
    case greenFlag = "Green Flag"
    case redFlag = "Red Flag"
    case justALog = "Just a log"
    case command = "Command"
    
    var msgColor: Color {
        switch self {
        case .error:
            return .red
        case .event:
            return .orange
        case .notification:
            return .pink
        case .fatalError:
            return .purple
        case .greenFlag:
            return .green
        case .redFlag:
            return .red
        case .justALog:
            return .primary
        case .command:
            return .green
        }
    }
}

public struct DebugLog: Hashable {
    public var debugString: String = ""
    public var debugTimeStamp: TimeInterval = Date().timeIntervalSince1970
    public var msgType: DebugMsgType = .justALog
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
final public class MainDebugger: ObservableObject {
    public static var shared: MainDebugger = MainDebugger()

    @Published public var debugLogs: [DebugLog] = []
    private var isDebuggerActive: Bool = false // not active by default to save resources
    public var logFileUrl: NSURL?
    
    public func turnOnOff(_ on: Bool) {
        switch on {
        case true:
            turnOn()
        case false:
            turnOff()
        }
    }
    
    private func turnOn() {
        isDebuggerActive = true
        MainDebugger.shared.append("Main Debugger turned ON", .greenFlag)
    }
    
    private func turnOff() {
        isDebuggerActive = false
        debugLogs = []
        MainDebugger.shared.append(newLog: DebugLog(debugString: "Main Debugger turned OFF", debugTimeStamp: Date().timeIntervalSince1970, msgType: .redFlag))
    }
    
    public func append (_ msg: String, _ type: DebugMsgType = .justALog) {
        if isDebuggerActive {
            self.append(newLog: DebugLog(debugString: msg, debugTimeStamp: Date().timeIntervalSince1970, msgType: type))
        }
        printToConsole(msg)
    }
    
    private func append (newLog: DebugLog) {
        writeLog(logString: newLog.debugString)
        // as it impacts UI let's secure it happens in the main queue
        DispatchQueue.main.async {
            self.debugLogs.insert(newLog, at: 0)
        }
    }
    
    public func reset () {
        // as it impacts UI let's secure it happens in the main queue
        DispatchQueue.main.async {
            self.debugLogs = []
        }
    }
    
    public func exportLogFile() {
        deleteLogFile()
        createLogFile()
        writeDebugLogsToFile()
    }
    
    public func writeLog(logString: String) {
        if self.logFileUrl != nil {
            do {
                try logString.write(to: self.logFileUrl! as URL, atomically: true, encoding: .utf8)
            } catch {
                printToConsole("Failed to write full log text to file")
            }
        }
    }
    
    public func writeDebugLogsToFile() {
        var fullLogText = "Epilepsy Research Kit Logfile \n"
        for log in self.debugLogs {
            let dateTimeStamp = Date.init(timeIntervalSince1970: log.debugTimeStamp).toStdString()
            fullLogText = "\(fullLogText) \n\(dateTimeStamp) \(log.debugString)"
        }
        writeLog(logString: fullLogText)
    }
    
    public func createLogFile() {
        //  Get file path
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        else {
            printToConsole("Failed to search through directories")
            return
        }
        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            printToConsole("Unable to create directory \(error.debugDescription)")
        }
        let fileName = "LogTest.json"
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(fileName)
        else {
            printToConsole("Failed create logFile path URL")
            return
        }
        if !fileManager.createFile(atPath: writePath.path, contents: nil, attributes: nil) {
            printToConsole("Error creating log file")
            return
        }
        self.logFileUrl = NSURL(fileURLWithPath: writePath.path)
    }
    
    public func deleteLogFile() {
        if self.logFileUrl != nil {
            do {
                try FileManager.default.removeItem(at: self.logFileUrl! as URL)
            } catch {
                printToConsole("Error deleting log file")
            }
        }
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
struct DebugView: View {
    @ObservedObject var mainDebugger = MainDebugger.shared
    var appnName: String
    var buildnumber: String
    
    var body: some View {
        if #available(OSX 11.0, *) {
            LazyVStack {
                Text(appnName + " (" + buildnumber + ")")
                
                List {
                    ForEach(mainDebugger.debugLogs, id: \.self) {log in
                        Text("\(Date.init(timeIntervalSince1970: log.debugTimeStamp).toStdString()) -> \(log.debugString)")
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

struct DebugView_Previews: PreviewProvider {
    @available(OSX 10.15, *)
    static var previews: some View {
        DebugView(appnName: "RoberdanToolBox", buildnumber: "1.0")
    }
}
