//
//  MailView.swift
//  used to send email within an app
//
//  Created by Roberto D’Angelo on 22/12/20.
//

#if os(iOS)
import SwiftUI
import MessageUI
import UIKit

@available(iOS 14.0, *)
public struct ShareAFeedbackView: View {
    @State var result: Result<MFMailComposeResult, Error>?
    @State var isShowingMailView: Bool = false

    public init() {}

    public var body: some View {
        VStack {
            HStack {
                Button("Share a feedback", action: {
                    self.isShowingMailView.toggle()
                })
                .disabled(!MFMailComposeViewController.canSendMail())
                .sheet(isPresented: $isShowingMailView) {
                    MailView(result: self.$result,
                             attachSharedMainDebuggerLog: false,
                             recipients: ["roberdan@fightthestroke.org"],
                             subject: "MirrorHR Feedback",
                             messageBody: "<p>Feedback on MirrorHR</p>")
                }
            }
        }
    }
}

@available(iOS 14.0, *)
public struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding public var result: Result<MFMailComposeResult, Error>?
    public var attachSharedMainDebuggerLog: Bool?
    public var recipients: [String]?
    public var subject: String?
    public var messageBody: String?
    
    public init(result: Binding<Result<MFMailComposeResult, Error>?>, attachSharedMainDebuggerLog: Bool?,
        recipients: [String]?,
        subject: String?,
        messageBody: String?) {
            _result = result
            self.attachSharedMainDebuggerLog = attachSharedMainDebuggerLog
            self.recipients = recipients
            self.subject = subject
            self.messageBody = messageBody
    }
    
    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding public var presentation: PresentationMode
        @Binding public var result: Result<MFMailComposeResult, Error>?

        public init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        public func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let mailViewController = MFMailComposeViewController()
        mailViewController.setToRecipients(recipients)
        mailViewController.setSubject(subject ?? "")
        mailViewController.setMessageBody(messageBody ?? "", isHTML: true)
        mailViewController.mailComposeDelegate = context.coordinator

        if attachSharedMainDebuggerLog ?? false {
            MainDebugger.shared.exportLogFile()
            guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            else {
                MainDebugger.shared.append("Failed to search through directories")
                return mailViewController
            }
            let fileName = "LogTest.json"
            guard let logPath = NSURL(fileURLWithPath: path).appendingPathComponent(fileName)
            else {
                MainDebugger.shared.append("Failed create logFile path URL")
                return mailViewController
            }
            if let data = NSData(contentsOfFile: logPath.path) {
                mailViewController.addAttachmentData(data as Data, mimeType: "application/json", fileName: fileName)
            }
        }
        

        return mailViewController
    }

    public func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}
#endif
