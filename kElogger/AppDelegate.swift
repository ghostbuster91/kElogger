import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow?
    
    private var loginWindow: LoginWindow? = nil
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        loginWindow = LoginWindow(windowNibName: "LoginWindow")
        loginWindow?.showWindow(nil)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

