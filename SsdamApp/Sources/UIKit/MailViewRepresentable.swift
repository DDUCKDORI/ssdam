//
//  MailViewRepresentable.swift
//  Ssdam
//
//  Created by 김재민 on 1/9/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import MessageUI
import SwiftUI

struct MailComposeViewController: UIViewControllerRepresentable {
    let recipient: String = "ssdami9345@gmail.com"
    let subject: String = "[쓰담] - 이메일 문의"
    let messageBody: String = ""

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = context.coordinator
        mailComposeViewController.setToRecipients([recipient])
        mailComposeViewController.setSubject(subject)
        mailComposeViewController.setMessageBody(messageBody, isHTML: false)
        return mailComposeViewController
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        // Nothing to update here
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposeViewController

        init(_ parent: MailComposeViewController) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
}
