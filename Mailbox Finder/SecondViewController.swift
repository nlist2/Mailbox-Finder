//
//  SecondViewController.swift
//  Mailbox Finder
//
//  Created by John List on 11/12/20.
//  Copyright © 2020 Noah List. All rights reserved.
//

import UIKit
import MessageUI

class SecondViewController: UIViewController, MFMailComposeViewControllerDelegate{

    @IBOutlet weak var FeedbackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Feedback button styling
        FeedbackButton.layer.cornerRadius = 5
    }
    
    
    // On feedback button click, launch email as a pop up with the following default values
    @IBAction func launchEmail(sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            let messageBody = ""
            let toRecipents = ["nlist@college.harvard.edu", "eelliott@college.harvard.edu"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            mc.setSubject("Chicago Mailbox Mapper Feedback")
            self.present(mc, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
