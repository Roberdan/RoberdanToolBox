//
//  MailView.swift
//  used to send email within an app
//
//  Created by Roberto D’Angelo on 22/12/20.
//

import SwiftUI
import MessageUI
import UIKit

public struct MailView: UIViewControllerRepresentable {
    var mainDebugger: MainDebugger = MainDebugger.shared

    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
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
        mailViewController.setToRecipients(["roberdan@fightthestroke.org"])
        mailViewController.setSubject("Feedback on MirrorHR")
        mailViewController.setMessageBody("<p>Feedback on MirrorHR</p>", isHTML: true)
        mailViewController.mailComposeDelegate = context.coordinator

        mainDebugger.exportLogFile()
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        else {
            mainDebugger.append("Failed to search through directories")
            return mailViewController
        }
        let fileName = "LogTest.json"
        guard let logPath = NSURL(fileURLWithPath: path).appendingPathComponent(fileName)
        else {
            mainDebugger.append("Failed create logFile path URL")
            return mailViewController
        }
        if let data = NSData(contentsOfFile: logPath.path) {
            mailViewController.addAttachmentData(data as Data, mimeType: "application/json", fileName: fileName)
        }

        return mailViewController
    }

    public func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}
