import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow?
    var loginWindowControler: LoginWindowController?
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        loginWindowControler = LoginWindowController()
        loginWindowControler?.showWindow(nil)
    }
    
}

