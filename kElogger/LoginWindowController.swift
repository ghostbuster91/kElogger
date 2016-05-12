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
        presentProgressBarAfterThreeSeconds()
    }
    
    override var windowNibName : String! {
        return "LoginWindowController"
    }
    
    func configureMainViewController() {
        contentViewController = LoginViewController(closeAction: {
            self.close()
        })
    }
    
    func presentProgressBarAfterThreeSeconds() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { [weak self] in
            let progressVC = ProgressViewController()
            self?.contentViewController?.presentViewControllerAsSheet(progressVC)
            progressVC.start()
        }
    }
    
}
