import Foundation
import AppKit

class KeyListener {
    
    var firebase: Firebase
    var keystrokes : Int
    var mouseEvents : Int
    
    init(firebase: Firebase, keystrokes: Int, mouseEvents: Int){
        self.firebase = firebase
        self.keystrokes = keystrokes
        self.mouseEvents = mouseEvents
    }
    
    func start(){
        acquirePrivileges()
        
        NSEvent.addGlobalMonitorForEventsMatchingMask(
            .KeyDownMask, handler: {(event: NSEvent) in
                print(String(event.characters!))
                self.keystrokes += 1
//                 notifier.showNotification(String(event.characters!))
        })
        NSEvent.addGlobalMonitorForEventsMatchingMask(
            [.LeftMouseDownMask, .RightMouseDownMask], handler: {(event: NSEvent) in
//                notifier.showNotification("mysz")
                print("mysz")
                self.mouseEvents += 1
        })
        
        createTimer()
    }
    
    private func acquirePrivileges() -> Bool {
        let accessEnabled = AXIsProcessTrustedWithOptions(
            [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true])
        
        if accessEnabled != true {
            print("You need to enable the keylogger in the System Prefrences")
        }
        return accessEnabled == true;
    }
    
    private func createTimer() -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(20.0,
                                                      target:   self,
                                                      selector: #selector(uploadData),
                                                      userInfo: nil,
                                                      repeats:  true)
    }
    
    @objc private func uploadData(){
        print("uploading data")
        let newData = ["keystrokes": keystrokes, "mouse": mouseEvents]
        firebase.updateChildValues(newData)
    }
}