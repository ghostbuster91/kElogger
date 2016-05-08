//
//  AppDelegate.swift
//  kElogger
//
//  Created by ghost on 08/05/16.
//  Copyright © 2016 ghost. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var githubTokenInput: NSTextField!
    @IBOutlet weak var window: NSWindow!

    @IBAction func helpAction(sender: AnyObject) {
        let urlString = NSURL(string: "https://github.com/settings/tokens")
        
        NSWorkspace.sharedWorkspace().openURL(urlString!)
    }

    @IBAction func loginAction(sender: AnyObject) {
        loginUser(githubTokenInput.stringValue)
    }
    
    private func loginUser(githubToken: String){
        let ref = Firebase(url: "https://luminous-heat-7872.firebaseio.com")
        ref.authWithOAuthProvider("github", token:githubToken,
                                  withCompletionBlock: { error, authData in
                                    if error != nil {
                                        // There was an error during log in
                                    } else {
                                        self.window.close()
                                        // We have a logged in Github user
                                    }
        })
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }



}

