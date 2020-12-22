//
//  DebugLogsView.swift
//  it shows a view with all the logs from MainDebugger.shared
//  and it enables to send an email with the logs attached
//  Created by Roberto D’Angelo on 22/12/20.
//

#if !os(watchOS)

import Foundation
import SwiftUI
import MessageUI

struct DebugLogsView: View {
    @ObservedObject var myDebugger: MainDebugger = MainDebugger.shared
    @State var result: Result<MFMailComposeResult, Error>?
    @State var isShowingMailView = false
    var body: some View {
        VStack {
            HStack {
                Button("Share a feedback", action: {
                    self.isShowingMailView.toggle()
                })
                .disabled(!MFMailComposeViewController.canSendMail())
                .sheet(isPresented: $isShowingMailView) {
                    MailView(result: self.$result,
                             attachSharedMainDebuggerLog: true,
                             recipients: ["roberdan@fightthestroke.org"],
                             subject: "MirrorHR Feedback",
                             messageBody: "<p>Feedback on MirrorHR</p>")
                }
            }
            DebuggerLogsView()
        }
    }
}

struct DebuggerLogsView: View {
    @ObservedObject var myDebugger: MainDebugger = MainDebugger.shared

    var body: some View {
        return List(myDebugger.debugLogs.reversed(), id: \.self) { logs in
            LogsRow(logs: logs)
        }
    }
}

struct DebugLogsView_Previews: PreviewProvider {
    static var previews: some View {
        DebugLogsView()
    }
}

struct LogsRow: View {
    var logs: DebugLog

    var body: some View {
        HStack {
            Text("\(logs.debugTimeStamp.toTimeStampFormatter())")
            Text("\(logs.debugString)")
        }
    }
}
#endif
