//
//  Dialog.swift
//  kElogger
//
//  Created by ghost on 11/05/16.
//  Copyright © 2016 ghost. All rights reserved.
//

import Foundation
import Cocoa

func dialogOK(message: String, text: String) {
    let myPopup: NSAlert = NSAlert()
    myPopup.messageText = message
    myPopup.informativeText = text
    myPopup.alertStyle = NSAlertStyle.WarningAlertStyle
    myPopup.addButtonWithTitle("OK")
    myPopup.runModal()
}