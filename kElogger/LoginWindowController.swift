//
//  loginWindowController.swift
//  kElogger
//
//  Created by ghost on 11/05/16.
//  Copyright © 2016 ghost. All rights reserved.
//

import Cocoa

class LoginWindowController: NSWindowController {
        
    override func windowDidLoad() {
        super.windowDidLoad()
        
        configureMainViewController()
    }
    
    override var windowNibName : String! {
        return "LoginWindowController"
    }
    
    func configureMainViewController() {
        contentViewController = LoginViewController(closeAction: {
            self.close()
            self.presentProgressBar()
        })
    }
    
    func presentProgressBar() {
        let progressVC = ProgressViewController()
        progressVC.closeAction = { self.close() }
        self.contentViewController?.presentViewControllerAsSheet(progressVC)
        progressVC.start()
    }
}
